# `lib/system/`

Cross-cutting OS shape — the configuration that should look the same on every
host regardless of which physical machine is running it.

## Layout

- `base.nix` — root of the systems layer. Sets audio, display manager, desktop
  environment, polkit, dbus, PAM/kwallet integration, etc. (Core nix store
  policy, locale, shell and stateVersion live in `core.nix`; the XDG portal is
  left to the Plasma 6 module, which registers the kde + gtk backends natively.)
- `power-management.nix` — power-profiles-daemon, thermald, default lid/power
  button policy, polkit rules for non-interactive suspend.
- `xbox-controller.nix` — xpadneo driver enablement.
- `hyprpolkitagent.nix` — **sequestered**: not imported. Custom systemd unit for
  the Hyprland polkit agent; Plasma provides polkit-kde-agent natively. See the
  file's header for re-activation steps.
- `hyprland/` — **sequestered**: not imported. See the file's header for
  re-activation steps.
- `wifi-profiles/` — declarative WiFi connection fragments (currently unused;
  see comment in `lib/hosts/default.nix` for the manual nmcli flow).

## What goes here vs `lib/hardware/`

The systems layer should be portable: every line should make sense on any
chassis. If a host wants to override a default, the option uses
`lib.mkDefault` here so a hardware module can override per-machine.

## What goes here vs `lib/hosts/`

The systems layer defines _what the OS looks like_. The hosts layer defines
_which hosts compose which combination of hardware + system + users_. Don't
introduce host identity (hostname, host-specific services) here; that's
hosts-layer business.

## Conventions

- Defaults that hardware modules might reasonably override use `lib.mkDefault`.
- When dropping or replacing an approach, append a `── Anex: prior approaches ──`
  block at the bottom of the file. Don't leave dead config inline.
