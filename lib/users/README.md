# `lib/users/`

Per-user Home Manager configurations, intended to be portable across machines.

## Layout

- `brojo/`
  - `home.nix` — root of the user env. Lists user packages and imports
    `./programs`.
  - `programs/` — per-program configuration (zsh, git, neovim, ghostty,
    rofi, dunst, OBS, etc.) plus the user-side power-management.
  - `programs/hyprland/` — **sequestered**: not imported. Holds the Hyprland
    user config, swaylock, hypridle, waybar, the wallpaper fetch, and the
    Hyprland-specific power keybindings fragment. See the file's header for
    re-activation steps.

## What goes here vs `lib/system/`

Anything user-scoped (dotfiles, per-user services, shell, editor) lives here.
System-scoped configuration (PAM, system services, kernel modules, drivers)
lives under `lib/system/` or `lib/hardware/`.

A user module should not assume which physical machine it is running on. If a
package only exists on one machine (e.g. NVIDIA-specific tools), gate it from
the host or hardware layer instead of from here.

## Adding a user

1. Add a sibling directory: `lib/users/<user>/home.nix` plus a `programs/`
   tree.
2. Wire it into `flake.nix`'s home-manager block:
   `home-manager.users.<user> = import ./lib/users/<user>/home.nix;`
3. Make sure the matching system user exists (declared from
   `lib/hosts/default.nix` or a host-specific module).
