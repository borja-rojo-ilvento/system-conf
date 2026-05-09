# CLAUDE.md

Guidance for Claude Code working on this repo.

## Project overview

Personal flake-based NixOS configuration. Two machines today: `jaro` (Lenovo
ThinkPad P14s Gen 2, hybrid Intel + NVIDIA T500) and `everest` (custom desktop
build, hardware dir `bung-box`). Active session on every host is Plasma 6 /
Wayland.

## Common commands

```bash
# Build and switch on this host
sudo nixos-rebuild switch --flake .#jaro
sudo nixos-rebuild switch --flake .#everest

# Test without switching
nixos-rebuild build --flake .#jaro

# Eval-only check
nix flake check --no-build

# Update inputs
nix flake update
```

## Layout

Four layers under `lib/`. Each layer has a `README.md` describing its role and
conventions; read those before making structural changes.

- `lib/hardware/` — per-machine hardware specs.
- `lib/system/`   — cross-cutting OS shape (audio, locale, DM, power, portals).
- `lib/users/`    — Home Manager user envs, portable across machines.
- `lib/hosts/`    — composition layer wiring hardware + system + users.

There is no top-level `systems/` directory. The flake assembles a configuration
directly from one hardware module + the hosts function + the user modules. The
system name (used by `--flake .#<name>`) and the hardware directory name are
independent — the same hardware can host different system compositions over
time (e.g. a future server build reusing `bung-box` hardware).

## Sequestered modules

`lib/system/hyprland/` and `lib/users/brojo/programs/hyprland/` are intact on
disk but **not** on the active import path. Re-activation steps live in each
sequestered `default.nix`.

When in doubt: check whether a file is imported by walking from `flake.nix`
through `lib/hosts/` and `lib/users/brojo/home.nix`. Dead modules are kept for
reference, not for behavior.

## Conventions

- Hardware-specific knobs (e.g. `hardware.bluetooth`, GPU PRIME setup) belong
  in the corresponding `lib/hardware/machines/<machine>/default.nix`, not in
  `lib/system/base.nix`.
- The hosts layer should not introduce compositor-specific or session-specific
  config; it composes.
- When dropping or replacing a configuration approach, leave a short
  `── Anex: prior approaches ──` block at the bottom of the affected file
  documenting what was tried and why it was dropped. This is the project's way
  of preserving institutional memory without comment-bloating live code.

## Parameter passing

The hosts layer takes `hostname` as a function argument:

```nix
(import ./lib/hosts { hostname = "jaro"; })
```

Flake inputs that hardware modules need (currently `nixos-hardware`,
`home-manager`) are passed via `specialArgs` from `flake.nix`.

## Verifying suspend/resume on jaro

After any NVIDIA-touching change:

1. `cat /sys/bus/pci/devices/0000:01:00.0/power/runtime_status` should read
   `suspended` at idle (no offloaded client running).
2. `nvidia-smi` should report no graphics processes attached at idle.
3. `cat /sys/power/mem_sleep` should show `s2idle [deep]` (BIOS Sleep State =
   "Linux S3").
4. Use the dGPU explicitly with `nvidia-offload <command>`.
