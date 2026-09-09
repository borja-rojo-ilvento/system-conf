# `lib/services/`

One file per service that a host may opt into. Unlike the other layers,
nothing here is imported implicitly — a host picks services explicitly from
`flake.nix`.

## Layout

- `gitea.nix`  — plain config fragment. Enables `services.gitea` with this
  network's settings baked in. No options of its own.
- `valheim.nix` — a real NixOS module: declares `options.services.valheim`
  and its own system user. Imported by `snow`.

Both shapes are fine. Use a plain fragment when the upstream module already
does the work and only site-specific values are needed; write a module with
options when the service has no upstream module, or when the same service
would be configured differently per host.

## Valheim

`services.valheim` packages the dedicated server, its `valheim` system user,
the backup timers, the scheduled update restart, and the firewall holes.
Turn-key defaults; the only value with no sensible default is `passwordFile`.

### What Nix owns, and why

Valheim has **no server config file**. Name, password, world, ports,
difficulty modifiers, save interval — all of it is command-line arguments,
and upstream's notion of configuration is hand-editing the shipped
`start_server.sh`. That script lives in the Steam install, which
`steamcmd ... validate` rewrites on every start, so edits there do not
survive. The launch command has to be owned by Nix; there is nowhere else
durable to put it.

The one real exception is the three permission lists in `save/` —
`adminlist.txt`, `bannedlist.txt`, `permittedlist.txt`. Those are operational
data, not configuration, and default to Nix-untouched so that banning someone
does not require a rebuild. Set `admins` / `bannedPlayers` /
`permittedPlayers` to a list only if you want the roster in git instead; the
file is then rewritten on every start and hand edits are lost.

### Password

One password, typed by players when joining. Valheim has no per-world or
per-user passwords, and it is unrelated to the `valheim` Unix account (which
is SSH-key only and has no login password). Like every other setting it is a
command-line argument, so the only real question is where the value comes
from. Three answers, in descending order of how declarative they are:

```nix
# 1. Inline. A rebuild+switch is the entire deployment.
services.valheim.password = "vikingsonly";

# 2. A file in this repo, copied into the store with everything else.
services.valheim.passwordFile = ./valheim-password;

# 3. A file placed on the host by hand, never in the store or in git.
services.valheim.passwordFile = "/var/lib/valheim/password";
```

`snow` uses (1). The value ends up in the Nix store — world-readable to local
accounts on the target — and in this repository's git history. For a server
shared with friends, that buys a deployment with no manual step on the host
and no state that a rebuild cannot reproduce, which is worth more than the
secrecy. (2) has the same exposure but keeps the literal out of the module
source. Reach for (3) only if the value genuinely must not be in the store,
and accept that the host then has a hand-placed file that `nixos-rebuild`
does not manage:

```bash
install -o valheim -g valheim -m 0400 /dev/stdin \
  /var/lib/valheim/password <<< 'yourpassword'
```

`password` and `passwordFile` are mutually exclusive.

Two rules the game enforces by silently refusing to boot: at least 5
characters, and not a substring of either the server name or the world name.
With `password` these are checked at **eval time**, so a bad value fails
`nix flake check` rather than the twentieth restart. With `passwordFile` the
contents are unknown until the service runs, so the start script checks them
there and exits with a real message.

Changing the password — or any launch argument — changes the start script's
store path, which changes the unit, so `nixos-rebuild switch` restarts the
server itself. Nothing extra to remember.

### Difficulty

```nix
services.valheim = {
  preset = "hard";                              # -preset
  modifiers = { raids = "none"; portals = "casual"; };  # -modifier k v
  setKeys = [ "nomap" ];                        # -setkey k
};
```

`preset` is emitted first, because the server applies arguments in order and
a preset overwrites modifiers set before it. Modifier keys are checked at eval
time — a typo is otherwise silent, and the world quietly runs on defaults.

### State

Everything lives under `/var/lib/valheim/valheim-server/`:

| path                | contents                                    | back up? |
| ------------------- | ------------------------------------------- | -------- |
| `game/`             | Steam install, refreshed on every start     | no       |
| `save/`             | worlds, characters, permission lists        | **yes**  |
| `backups/<tier>/`   | tarballs of `save/`, pruned per tier        | —        |

### Updates

Two mechanisms, one underneath the other:

- `updateOnStart` (default on) runs `steamcmd +app_update ... validate` at
  `ExecStartPre`. This is the self-healing part: it repairs a corrupted
  install and re-syncs to the build clients expect. **Every** start gets it,
  manual restarts included.
- `autoUpdate` (default on, `05:00`) is just a timer that restarts the
  service, which makes the above run unattended. Shutdown is SIGINT, which
  commits a world save first, so a restart is a consistent point and nothing
  is lost beyond the disconnection.

So "update now" and "restart" are the same operation. `valheim-update` is on
`PATH` for exactly that:

```bash
valheim-update                       # = systemctl restart valheim-server
systemctl list-timers 'valheim-*'    # when the next scheduled restart lands
```

To pin the server to whatever is on disk, set `updateOnStart = false` — but
it will stop accepting players after the next Valheim patch.

### Backups

`backups` is an attrset of named tiers. Each becomes its own service, timer,
and directory, so tiers prune independently rather than deleting each other's
archives. The default is what the table above describes:

```nix
services.valheim.backups = {
  hourly = { onCalendar = "hourly"; keep = 48; };   # 48 hours of cover
  daily  = { onCalendar = "daily";  keep = 30; };   # 30 days of cover
};
```

Add a tier by adding a key; `keep` is a count of archives, so the retention
window is `keep x onCalendar`. Set `backups = { }` to take none.

Underneath these, the game keeps its own backups inside `save/worlds_local`
on its own schedule (`builtinBackups`, default 4). Those are written by the
server itself, so they are internally consistent in a way that tarring a
running world cannot guarantee — worth leaving on as the floor under the
tiers.

### Operating it

As `brojo`, or over SSH as `valheim`, which holds polkit rights over the
`valheim-*` units and nothing else:

```bash
systemctl status valheim-server
journalctl -u valheim-server -f
systemctl start valheim-backup-daily   # ad-hoc backup into the daily tier
```

The `valheim` account's login shell defines `vh-*` aliases over all of the
above; see `lib/users/valheim/`.
