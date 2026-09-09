# Valheim dedicated server.
#
# Turn-key: `services.valheim.enable = true;` plus a password file is enough.
# Everything else has a working default.
#
#
# ── Where configuration lives ───────────────────────────────────────────────
#
# Valheim has no server config file. Every setting — name, password, world,
# ports, difficulty modifiers, save and backup intervals — is a command-line
# argument, and upstream's idea of "configuration" is that you hand-edit the
# shipped `start_server.sh`. That file lives inside the Steam install, which
# `steamcmd ... validate` rewrites on every start, so edits there do not
# survive. The launch command therefore has to be owned by Nix; there is no
# other durable home for it.
#
# The exceptions are the three permission lists — adminlist.txt,
# bannedlist.txt, permittedlist.txt — which the server reads out of the save
# directory. Those are genuinely operational: you want to ban someone without
# a rebuild. They default to Nix-untouched, and are only managed if the
# corresponding option is set to a non-null list.
#
#
# ── Data directory layout ───────────────────────────────────────────────────
#
#   <dataDir>/game/           Steam install. Disposable; re-downloaded on demand.
#   <dataDir>/save/           worlds_local/, characters_local/, and the three
#                             permission lists. The only part that matters.
#   <dataDir>/backups/<tier>/ Tarballs of save/, one directory per backup tier.
#
# `-savedir` is passed explicitly rather than letting the server scatter state
# into ~/.config/unity3d/IronGate/Valheim, so the precious data sits in one
# directory that can be snapshotted whole.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.valheim;

  # Steam app IDs. 896660 is the dedicated server; 892970 is the game itself,
  # which the server binary expects to see in $SteamAppId.
  serverAppId = "896660";
  gameAppId = "892970";

  gameDir = "${cfg.dataDir}/game";
  saveDir = "${cfg.dataDir}/save";
  backupRoot = "${cfg.dataDir}/backups";

  # Modifier keys the server understands. A typo is otherwise silent — the
  # server ignores the flag and starts on default difficulty — so these are
  # checked at eval time.
  knownModifiers = [
    "combat"
    "deathpenalty"
    "resources"
    "raids"
    "portals"
  ];
  knownSetKeys = [
    "nobuildcost"
    "playerevents"
    "passivemobs"
    "nomap"
  ];

  # Permission lists, written only for the options that are non-null.
  managedLists = lib.filterAttrs (_: v: v != null) {
    "adminlist.txt" = cfg.admins;
    "bannedlist.txt" = cfg.bannedPlayers;
    "permittedlist.txt" = cfg.permittedPlayers;
  };

  writeListCommands = lib.concatStrings (
    lib.mapAttrsToList (
      file: ids:
      let
        rendered = pkgs.writeText "valheim-${file}" (lib.concatMapStrings (id: id + "\n") ids);
      in
      "install -m 0644 ${rendered} ${lib.escapeShellArg "${saveDir}/${file}"}\n"
    ) managedLists
  );

  # Fetch/update the server from Steam, then refresh any Nix-managed lists.
  #
  # `validate` makes this idempotent and self-healing: a partially written or
  # corrupted install is repaired on the next start rather than needing manual
  # intervention. It is also what keeps the server on the build that clients
  # expect, since Valheim rejects version mismatches.
  updateScript = pkgs.writeShellScript "valheim-update" ''
    set -euo pipefail
    mkdir -p ${lib.escapeShellArg gameDir} ${lib.escapeShellArg saveDir}
    ${lib.optionalString cfg.updateOnStart ''
      ${lib.getExe pkgs.steamcmd} \
        +@sSteamCmdForcePlatformType linux \
        +force_install_dir ${lib.escapeShellArg gameDir} \
        +login anonymous \
        +app_update ${serverAppId} validate \
        +quit
    ''}
    ${writeListCommands}
  '';

  # Order matters: a preset overwrites modifiers set before it, so the preset
  # goes first and individual modifiers refine it afterwards.
  worldArgs =
    lib.optionals (cfg.preset != null) [
      "-preset"
      cfg.preset
    ]
    ++ lib.concatLists (
      lib.mapAttrsToList (k: v: [
        "-modifier"
        k
        v
      ]) cfg.modifiers
    )
    ++ lib.concatMap (k: [
      "-setkey"
      k
    ]) cfg.setKeys;

  startScript = pkgs.writeShellScript "valheim-start" ''
    set -euo pipefail

    password=""
    ${
      # A declarative password is validated at eval time by the assertions
      # below, so it needs no runtime checking — a bad one fails the build
      # rather than the twentieth restart.
      if cfg.password != null then
        "password=${lib.escapeShellArg cfg.password}"
      else
        lib.optionalString (cfg.passwordFile != null) ''
          password="$(head -n1 ${lib.escapeShellArg cfg.passwordFile} | tr -d '\r\n')"

          # Contents of an out-of-store file are unknown until now, so the
          # rules the game enforces by silently refusing to boot get checked
          # here instead.
          if [ -n "$password" ]; then
            if [ "''${#password}" -lt 5 ]; then
              echo "valheim: password must be at least 5 characters" >&2
              exit 1
            fi
            case ${lib.escapeShellArg cfg.serverName} in
              *"$password"*)
                echo "valheim: password must not appear inside the server name" >&2
                exit 1
                ;;
            esac
            case ${lib.escapeShellArg cfg.worldName} in
              *"$password"*)
                echo "valheim: password must not appear inside the world name" >&2
                exit 1
                ;;
            esac
          fi
        ''
    }

    export SteamAppId=${gameAppId}
    export LD_LIBRARY_PATH="${gameDir}/linux64''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

    args=(
      -nographics
      -batchmode
      -name ${lib.escapeShellArg cfg.serverName}
      -port ${toString cfg.port}
      -world ${lib.escapeShellArg cfg.worldName}
      -savedir ${lib.escapeShellArg saveDir}
      -public ${if cfg.public then "1" else "0"}
      -saveinterval ${toString cfg.saveIntervalSeconds}
      -backups ${toString cfg.builtinBackups}
      ${lib.optionalString cfg.crossplay "-crossplay"}
      ${lib.escapeShellArgs worldArgs}
      ${lib.escapeShellArgs cfg.extraArgs}
    )
    if [ -n "$password" ]; then
      args+=(-password "$password")
    fi

    cd ${lib.escapeShellArg gameDir}
    exec ./valheim_server.x86_64 "''${args[@]}"
  '';

  # $1 = tier name, $2 = archives to retain.
  backupScript = pkgs.writeShellScript "valheim-backup" ''
    set -euo pipefail
    tier="$1"
    keep="$2"
    dir=${lib.escapeShellArg backupRoot}/"$tier"
    mkdir -p "$dir"
    stamp="$(date -u +%Y%m%dT%H%M%SZ)"
    ${lib.getExe pkgs.gnutar} -czf "$dir/valheim-$stamp.tar.gz" \
      -C ${lib.escapeShellArg saveDir} .
    # Prune by count, newest kept. Each tier prunes only its own directory.
    ls -1t "$dir"/valheim-*.tar.gz | tail -n +$((keep + 1)) | xargs -r rm -f
  '';

  # Manual update. The update runs at ExecStartPre, so "update now" and
  # "restart" are the same operation — this just gives it an obvious name.
  updateCommand = pkgs.writeShellScriptBin "valheim-update" ''
    exec ${lib.getExe' pkgs.systemd "systemctl"} restart valheim-server "$@"
  '';
in
{
  options.services.valheim = {
    enable = lib.mkEnableOption "the Valheim dedicated server";

    serverName = lib.mkOption {
      type = lib.types.str;
      default = "Valheim";
      description = "Name shown in the server browser and in-game join list.";
    };

    worldName = lib.mkOption {
      type = lib.types.str;
      default = "Midgard";
      description = ''
        World to load from the save directory, created on first start if it
        does not exist. Corresponds to
        `<dataDir>/save/worlds_local/<worldName>.db`.
      '';
    };

    # The server's single join password. Valheim has no per-world or per-user
    # passwords, and this is unrelated to the Unix account's password. It is a
    # command-line argument with no config-file alternative, so the only
    # question is where the value comes from — hence two options.

    password = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "vikingsonly";
      description = ''
        The join password, declared inline. This is the option to reach for if
        you want `nixos-rebuild switch --flake .#<host>` to be the whole
        deployment: the value travels with the configuration, a change to it
        restarts the service on the next switch, and no file has to be placed
        on the host by hand.

        The cost is that the value lands in the Nix store, which is
        world-readable to local accounts on the target machine, and in the
        git history of this repository. For a game server shared with friends
        that is usually the right trade; for anything else, use
        {option}`passwordFile`.

        Validated at eval time — the length and substring rules below fail the
        build rather than the service.
      '';
    };

    passwordFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/var/lib/valheim/password";
      description = ''
        Path to a file whose first line is the join password, read at service
        start. Mutually exclusive with {option}`password`.

        Two distinct uses. An absolute path outside the store
        (`"/var/lib/valheim/password"`) keeps the value off both the store and
        git, at the cost of a manual step on the host. A path *in this
        repository* (`./valheim-password`) is copied into the store and
        deployed with everything else, which stays declarative while keeping
        the value out of the module source — though it is then no more secret
        than {option}`password`.

        The game requires at least 5 characters, and the password must not
        appear as a substring of the server name or world name. A file's
        contents are unknown at eval time, so those are checked at start.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 2456;
      description = ''
        Base UDP port. The server also binds `port + 1` as the Steam query
        port, so both are opened when {option}`openFirewall` is set.
      '';
    };

    public = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        List the server in the public community browser. When false, players
        join by address via "Join IP".
      '';
    };

    crossplay = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Use the PlayFab crossplay backend, letting non-Steam (Xbox/Game Pass)
        clients join via a join code. Note that this routes through PlayFab
        rather than direct UDP.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open the game and query UDP ports in the firewall.";
    };

    # ── World difficulty ──────────────────────────────────────────────────

    preset = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "casual"
          "easy"
          "normal"
          "hard"
          "hardcore"
          "immersive"
          "hammer"
        ]
      );
      default = null;
      description = ''
        World modifier preset. Applied before {option}`modifiers`, matching
        the server's own argument ordering: a preset overwrites anything set
        before it, so individual modifiers refine the preset rather than the
        other way around.
      '';
    };

    modifiers = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        raids = "none";
        portals = "casual";
      };
      description = ''
        Valued world modifiers, passed as `-modifier <key> <value>`. Valid
        keys: ${lib.concatStringsSep ", " knownModifiers}.
      '';
    };

    setKeys = lib.mkOption {
      type = lib.types.listOf (lib.types.enum knownSetKeys);
      default = [ ];
      example = [ "nomap" ];
      description = ''
        Boolean world modifiers, passed as `-setkey <key>`.
      '';
    };

    saveIntervalSeconds = lib.mkOption {
      type = lib.types.ints.positive;
      default = 1800;
      description = ''
        How often the server writes the world to disk. Also the ceiling on how
        much progress a crash can lose — the backup tiers below can only ever
        capture the last committed save.
      '';
    };

    builtinBackups = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 4;
      description = ''
        Number of backups the *game* keeps inside `save/worlds_local`, on its
        own schedule. These are written by the server itself, so they are
        internally consistent in a way an outside tarball of a running world
        cannot guarantee. Kept at the stock value; the tiers in
        {option}`backups` are the retention policy, this is the safety net
        underneath them.
      '';
    };

    # ── Accounts and permissions ──────────────────────────────────────────

    user = lib.mkOption {
      type = lib.types.str;
      default = "valheim";
      description = "User account that owns the data directory and runs the server.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "valheim";
      description = "Primary group of {option}`user`.";
    };

    home = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/valheim";
      description = ''
        Home directory of the server user. Kept under `/var/lib` rather than
        `/home` because this is service state, not a person's files — but the
        account is still a normal, SSH-loginable user.
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "${cfg.home}/valheim-server";
      defaultText = lib.literalExpression ''"''${config.services.valheim.home}/valheim-server"'';
      description = "Root of all server state: game install, saves, backups.";
    };

    authorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "SSH public keys permitted to log in as {option}`user`.";
    };

    admins = lib.mkOption {
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      default = null;
      example = [ "Steam_76561198000000000" ];
      description = ''
        Contents of `adminlist.txt`, one platform user ID per line, in
        `<Platform>_<UserID>` form.

        `null` — the default — means Nix does not touch the file, which is
        usually what you want: the permission lists are the one part of
        Valheim's configuration that is genuinely a data file, and banning
        someone should not require a rebuild. Set a list only if you would
        rather have the roster in git, in which case it is rewritten on every
        service start and hand edits are lost.
      '';
    };

    bannedPlayers = lib.mkOption {
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      default = null;
      description = "Contents of `bannedlist.txt`. See {option}`admins` for the tradeoff.";
    };

    permittedPlayers = lib.mkOption {
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      default = null;
      description = ''
        Contents of `permittedlist.txt`. A non-empty allowlist bans everyone
        absent from it. See {option}`admins` for the tradeoff.
      '';
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional arguments appended to the server command line.";
    };

    # ── Updates ───────────────────────────────────────────────────────────

    updateOnStart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Run `steamcmd +app_update ... validate` before every start. This is
        what keeps the server on the build clients expect, and repairs a
        damaged install without intervention. Turning it off pins the server
        to whatever is on disk, and it will stop accepting players after the
        next Valheim patch.
      '';
    };

    autoUpdate = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Restart the server on a schedule so {option}`updateOnStart` picks up
          new builds unattended. A restart shuts the server down with SIGINT,
          which commits a world save first, so no progress is lost beyond the
          disconnection itself.
        '';
      };

      onCalendar = lib.mkOption {
        type = lib.types.str;
        default = "05:00";
        description = ''
          systemd `OnCalendar` expression for the scheduled restart. Pick an
          hour nobody is playing.
        '';
      };
    };

    # ── Backups ───────────────────────────────────────────────────────────

    backups = lib.mkOption {
      default = {
        hourly = {
          onCalendar = "hourly";
          keep = 48;
        };
        daily = {
          onCalendar = "daily";
          keep = 30;
        };
      };
      description = ''
        Backup tiers. Each entry becomes its own timer, its own service, and
        its own directory under `<dataDir>/backups/<tier>/`, so tiers prune
        independently and never compete over the same archives.

        The default keeps 48 hourly and 30 daily archives of the save
        directory. Set to `{ }` to take no backups.
      '';
      example = lib.literalExpression ''
        {
          hourly = { onCalendar = "hourly"; keep = 48; };
          daily  = { onCalendar = "daily";  keep = 30; };
          weekly = { onCalendar = "Mon *-*-* 04:00:00"; keep = 12; };
        }
      '';
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            onCalendar = lib.mkOption {
              type = lib.types.str;
              description = "systemd `OnCalendar` expression for this tier.";
            };
            keep = lib.mkOption {
              type = lib.types.ints.positive;
              description = "Number of archives this tier retains before pruning oldest-first.";
            };
          };
        }
      );
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.password != null && cfg.passwordFile != null);
        message = "services.valheim: set password or passwordFile, not both.";
      }
      {
        assertion = cfg.password != null || cfg.passwordFile != null || !cfg.public;
        message = "services.valheim: a public server must set password or passwordFile.";
      }
      {
        assertion = cfg.password == null || builtins.stringLength cfg.password >= 5;
        message = "services.valheim.password: must be at least 5 characters.";
      }
      {
        assertion = cfg.password == null || !(lib.hasInfix cfg.password cfg.serverName);
        message = "services.valheim.password: must not appear inside serverName.";
      }
      {
        assertion = cfg.password == null || !(lib.hasInfix cfg.password cfg.worldName);
        message = "services.valheim.password: must not appear inside worldName.";
      }
      {
        assertion = lib.all (k: lib.elem k knownModifiers) (lib.attrNames cfg.modifiers);
        message =
          "services.valheim.modifiers: unknown key(s) "
          + lib.concatStringsSep ", " (lib.subtractLists knownModifiers (lib.attrNames cfg.modifiers))
          + ". Valid keys: "
          + lib.concatStringsSep ", " knownModifiers
          + ".";
      }
    ];

    users.groups.${cfg.group} = { };

    users.users.${cfg.user} = {
      isNormalUser = true;
      group = cfg.group;
      home = cfg.home;
      createHome = true;
      homeMode = "750";
      description = "Valheim dedicated server";
      openssh.authorizedKeys.keys = cfg.authorizedKeys;
    };

    environment.systemPackages = [ updateCommand ];

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir}  0750 ${cfg.user} ${cfg.group} -"
      "d ${gameDir}      0750 ${cfg.user} ${cfg.group} -"
      "d ${saveDir}      0750 ${cfg.user} ${cfg.group} -"
      "d ${backupRoot}   0750 ${cfg.user} ${cfg.group} -"
    ];

    systemd.services = lib.mkMerge [
      {
        valheim-server = {
          description = "Valheim dedicated server";
          wantedBy = [ "multi-user.target" ];
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];

          environment = {
            HOME = cfg.home;
            # steamcmd is an FHS wrapper; give it a stable, writable Steam root.
            XDG_DATA_HOME = "${cfg.home}/.local/share";
          };

          serviceConfig = {
            User = cfg.user;
            Group = cfg.group;
            WorkingDirectory = cfg.dataDir;

            ExecStartPre = "${updateScript}";
            ExecStart = "${lib.getExe pkgs.steam-run} ${startScript}";

            # Valheim saves the world on SIGINT and needs a moment to finish.
            # SIGTERM would leave the last interval of progress on the floor.
            KillSignal = "SIGINT";
            TimeoutStopSec = 120;

            Restart = "always";
            RestartSec = 10;

            # The Steam download is slow on first run; don't let systemd give up.
            TimeoutStartSec = "infinity";
          };
        };

        # Scheduled restart, which is what makes updateOnStart an auto-update.
        # Deliberately not chained to a backup tier: the SIGINT shutdown
        # commits a world save on its way out, so the restart is already a
        # consistent point.
        valheim-autoupdate = lib.mkIf cfg.autoUpdate.enable {
          description = "Restart the Valheim server to pick up game updates";
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${lib.getExe' pkgs.systemd "systemctl"} restart valheim-server";
          };
        };
      }

      # One service per backup tier.
      (lib.mapAttrs' (
        tier: opts:
        lib.nameValuePair "valheim-backup-${tier}" {
          description = "Valheim ${tier} save backup";
          serviceConfig = {
            Type = "oneshot";
            User = cfg.user;
            Group = cfg.group;
            ExecStart = "${backupScript} ${lib.escapeShellArg tier} ${toString opts.keep}";
          };
        }
      ) cfg.backups)
    ];

    systemd.timers = lib.mkMerge [
      {
        valheim-autoupdate = lib.mkIf cfg.autoUpdate.enable {
          description = "Restart the Valheim server to pick up game updates";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = cfg.autoUpdate.onCalendar;
            Persistent = true;
          };
        };
      }

      # One timer per backup tier.
      (lib.mapAttrs' (
        tier: opts:
        lib.nameValuePair "valheim-backup-${tier}" {
          description = "Valheim ${tier} save backup";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = opts.onCalendar;
            Persistent = true;
          };
        }
      ) cfg.backups)
    ];

    # Let the valheim user drive its own units over SSH without granting
    # general sudo. polkit is off by default on a headless host (it is
    # normally pulled in by the desktop modules), so enable it here — the rule
    # below is inert without it, and a rule-less `systemctl restart` over SSH
    # has no agent to authenticate against.
    security.polkit.enable = true;
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.systemd1.manage-units" &&
            subject.user == "${cfg.user}") {
          var unit = action.lookup("unit");
          if (unit && unit.indexOf("valheim-") === 0) {
            return polkit.Result.YES;
          }
        }
      });
    '';

    networking.firewall.allowedUDPPorts = lib.mkIf cfg.openFirewall [
      cfg.port
      (cfg.port + 1)
    ];
  };

  # ── Anex: prior approaches and why they were dropped ────────────────────────
  #
  # Tried: fetching the server purely with nix-community/steam-fetcher, which
  # pins (appId, depotId, manifestId, hash) and puts the whole install in the
  # store. Rejected as the default because Valheim refuses connections from
  # clients on a different build: every upstream patch would lock players out
  # until the manifest ID and hash were looked up by hand and the host
  # rebuilt. `steamcmd +app_update` at ExecStartPre trades store purity for a
  # server that tracks the client automatically, which is the property that
  # actually matters here. The install lives in <dataDir>/game and is fully
  # disposable — deleting it and restarting re-downloads.
  #
  # Tried: running valheim_server.x86_64 against a patched interpreter instead
  # of steam-run. Rejected because the binary resolves its data files relative
  # to the linker rather than to itself, so the Unity data directory is not
  # found. steam-run's FHS environment plus an explicit WorkingDirectory
  # avoids the problem entirely.
  #
  # Tried: letting the server use its default save location
  # (~/.config/unity3d/IronGate/Valheim). Rejected in favour of an explicit
  # -savedir so that worlds, characters and the permission lists sit in one
  # directory that can be backed up or moved as a unit.
  #
  # Tried: a single backup timer with one retention count. Rejected once more
  # than one retention horizon was wanted — a lone timer cannot express "48
  # hourly and 30 daily", and two timers writing into one directory would
  # prune each other's archives. Tiers now own a subdirectory each.
  #
  # Tried: managing adminlist.txt unconditionally from Nix. Rejected because
  # it makes banning someone mid-session a rebuild. The permission lists are
  # the one part of Valheim's configuration that is a real data file, so they
  # are left alone unless explicitly opted into.
}
