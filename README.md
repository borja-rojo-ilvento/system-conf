# NixOS System Configuration

Modular NixOS configuration using flakes with four-layer architecture for the ThinkPad P14s Gen2 "jaro" system.

## Quick Start

```bash
# Build and switch configuration
sudo nixos-rebuild switch --flake .#jaro

# Test without switching
nixos-rebuild build --flake .#jaro

# Update inputs
nix flake update
```

## Architecture

Four-layer modular design:

- **Hardware** (`lib/hardware/`): Pure hardware configs using nixos-hardware
- **Host Types** (`lib/hosts/`): System roles (productivity, server, etc.)
- **Users** (`lib/users/`): Home Manager user configurations
- **Systems** (`systems/`): Concrete deployments combining above layers

### Key Principles
- Hardware configs contain only hardware-specific settings
- Host types define system role and services, reusable across hardware
- User configs are portable across systems
- Each system combines exactly one hardware config, one host type, and users

## Directory Structure
```
.
├── flake.nix
├── systems/jaro/              # Concrete system deployment
├── lib/
│   ├── hardware/machines/     # Hardware-specific configs
│   ├── hosts/                 # Host type definitions
│   ├── users/brojo/          # User configurations
│   └── system/               # Shared system base
└── CLAUDE.md                 # Development guidance
```

## Adding New Systems
1. Create hardware config in `lib/hardware/machines/` (if new)
2. Create or reuse host type in `lib/hosts/`
3. Create system config in `systems/new-hostname/`
4. Add to `flake.nix` nixosConfigurations