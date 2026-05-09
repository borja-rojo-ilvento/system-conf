# TODO

Open items, scoped to this repo.

## Architecture

- [ ] **Hostname parameter passing.** `lib/hosts/default.nix` is currently a
      function `{ hostname }: { ... }: { ... }` invoked from `flake.nix`. An
      alternative is to drop `specialArgs`/the function shape and inline
      `{ networking.hostName = "<name>"; }` per host in `flake.nix`. The
      current shape is kept while only one host shape exists; revisit when a
      second host shape (e.g. server) lands.
- [ ] **Second host shape.** Once a non-productivity host is needed
      (server, media-server, …), split `lib/hosts/default.nix` into siblings
      and select per host from `flake.nix`.

## Sequestered modules

- [ ] **Hyprland.** `lib/system/hyprland/` and
      `lib/users/brojo/programs/hyprland/` are preserved but not imported.
      Decide whether to revive them, fold useful pieces into the Plasma
      config, or eventually delete.

## Verification

- [ ] **Suspend/resume regression check on jaro.** After the NVIDIA cleanup,
      confirm that
      `cat /sys/bus/pci/devices/0000:01:00.0/power/runtime_status` reads
      `suspended` at idle and that `nvidia-smi` reports no graphics processes
      attached when no `nvidia-offload` client is running.
