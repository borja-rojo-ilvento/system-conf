# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a modular NixOS system configuration repository using flakes. The architecture separates concerns across four layers: hardware, host types, users, and concrete systems. The current setup manages a ThinkPad P14s Gen2 laptop named "jaro" with KDE Plasma 6.

## Common Commands

```bash
# Build and switch to the configuration
sudo nixos-rebuild switch --flake .#jaro

# Test the configuration without switching
nixos-rebuild build --flake .#jaro

# Update flake inputs
nix flake update

# Check flake evaluation
nix flake check
```

## Architecture

### Layer Structure
- **`lib/hardware/`**: Pure hardware configurations, uses nixos-hardware flake
- **`lib/hosts/`**: Host type definitions (system roles like productivity, server)
- **`lib/users/`**: User configurations via Home Manager
- **`lib/system/`**: Shared system-level base configurations
- **`systems/`**: Concrete deployments combining the above layers

### Key Patterns
- Each concrete system (like `systems/jaro/`) combines exactly one hardware config, one host type, and one or more users
- Hardware configs contain only hardware-specific settings (no users, hostnames, or application services)
- Host types define system role and services, reusable across hardware
- User configs are portable across systems

### Parameter Passing
The system uses `specialArgs` to pass custom parameters like hostname to modules. When using `specialArgs`, all flake inputs used by modules must be explicitly inherited:

```nix
specialArgs = {
  inherit nixos-hardware home-manager claude-desktop;
  hostname = "jaro";
};
```

## Development Notes

### Adding New Systems
1. Create hardware config in `lib/hardware/machines/` (if new hardware)
2. Create or reuse host type in `lib/hosts/`
3. Create system config in `systems/new-hostname/`
4. Add to `flake.nix` nixosConfigurations

### Current Known Issues
- `specialArgs` requires explicit flake input inheritance (see TODO.md for alternative approaches being considered)
- Hardware profiles in `lib/hardware/profiles/` are currently unused but planned for reusable hardware patterns

### Testing Changes
Always test configuration builds before switching:
- Use `nixos-rebuild build --flake .#jaro` to verify configuration builds
- Hardware changes require careful testing due to potential boot/graphics issues
- User configuration changes can be tested independently via Home Manager