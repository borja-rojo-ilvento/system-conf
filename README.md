# NixOS System Configuration

Personal flake-based NixOS configuration for multiple machines.

## Quick start

```bash
# Build and switch on this host
sudo nixos-rebuild switch --flake .#jaro    # ThinkPad P14s Gen 2
sudo nixos-rebuild switch --flake .#everest # bung-box (custom desktop)

# Test without switching
nixos-rebuild build --flake .#jaro

# Update inputs
nix flake update
```

## Layered architecture

The configuration is split into four layers, each living under `lib/`. Each
layer has its own `README.md` describing its role and conventions.

| Layer        | Path           | Purpose                                                          |
|--------------|----------------|------------------------------------------------------------------|
| **hardware** | `lib/hardware/`| Per-machine hardware specs (CPU, GPU, BT radio, disk UUIDs).     |
| **system**   | `lib/system/`  | Cross-cutting OS shape (audio, locale, DM, power, portals).      |
| **users**    | `lib/users/`   | Home Manager user environments, portable across machines.        |
| **hosts**    | `lib/hosts/`   | Composition layer that wires hardware + system + users together. |

`flake.nix` defines a `nixosConfigurations.<name>` per machine, each importing
exactly one hardware module, the host composition function, and the user
modules through Home Manager.

## Adding a new machine

1. Add a directory under `lib/hardware/machines/<machine-name>/` with the
   generated `hardware-configuration.nix` and a `default.nix` for
   machine-specific knobs (GPU/BT/etc.).
2. Add a new entry under `nixosConfigurations` in `flake.nix` calling
   `import ./lib/hosts { hostname = "<system-name>"; }`.

The system name (used for `nixos-rebuild --flake .#<name>` and
`networking.hostName`) and the hardware directory name are independent: the
same hardware can host different system compositions over time.

## Notes

- BIOS: on the ThinkPad P14s Gen 2, set `Config → Power → Sleep State = "Linux S3"`
  for working suspend-to-RAM. Verify with `cat /sys/power/mem_sleep` (`deep`
  should be selected).
- Sequestered modules: `lib/system/hyprland/` and `lib/users/brojo/programs/hyprland/`
  are preserved on disk but intentionally not imported. The active session is
  Plasma 6 / Wayland everywhere. Each sequestered `default.nix` documents the
  steps to re-activate it.
