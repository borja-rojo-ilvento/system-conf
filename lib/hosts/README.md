# `lib/hosts/`

Composition layer. A host wires one hardware module + the systems layer + one
or more users into a complete `nixosConfiguration`.

## Layout

- `default.nix` — a function `{ hostname }: { ... }: { ... }` that imports
  `../system/base.nix`, sets `networking.hostName`, and adds the
  productivity-style services that every current host wants (Steam, Flatpak,
  the brojo user, OBS tuning, NetworkManager polkit).

Today there is exactly one host shape (`hosts/default.nix`) used by both
`jaro` and `everest`. As soon as a second shape is needed (e.g. a headless
server host), split the differences out into a sibling module and select per
host from `flake.nix`.

## What goes here vs `lib/system/`

The hosts layer expresses _intent for this kind of machine_: "this is a
productivity workstation, it runs Steam and Flatpak, brojo logs in here." The
systems layer is OS infrastructure that those hosts share.

If you find yourself adding a knob to the hosts layer that only applies to
one machine, it likely belongs in that machine's hardware module instead.

## Conventions

- Don't introduce compositor-specific or session-specific config here. The
  hosts layer composes; the systems layer chooses session.
- New host shapes should be sibling files (`server.nix`, `media-server.nix`,
  …), each importing `../system/base.nix` and adding their own service set.
