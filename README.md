# Personal NixOS System Configurations

This repository contains a modular NixOS configuration system designed for maintainability, reusability, and clear separation of concerns.

## Architecture Overview

The configuration is organized into three main conceptual layers:

### 1. Hardware Layer (`lib/hardware/`)
Defines pure hardware configurations and hardware-specific optimizations.

- **`machines/`**: Specific hardware configurations (e.g., `brojo-thinkpad-p14s-gen2`)
- **`profiles/`**: Reusable hardware profiles (e.g., `laptop.nix`, `desktop-plasma.nix`)

**Purpose**: Hardware configurations should be portable and contain only hardware-specific settings. They should not contain user configurations, hostname settings, or application-specific services.

### 2. Host Types (`lib/hosts/`)
Defines different types of host configurations based on their intended use.

- **`default.nix`**: Default productivity configuration
- Future examples: `server.nix`, `media-server.nix`, `build-server.nix`

**Purpose**: Host configurations define the role and services a machine should provide. They are reusable across multiple physical machines of the same type.

### 3. User Configurations (`lib/users/`)
Defines user-specific configurations using Home Manager.

- **`brojo/`**: User-specific home configuration and programs

**Purpose**: User configurations are portable across different machines and host types.

### 4. System Base (`lib/system/`)
Contains shared system-level configurations.

- **`base.nix`**: Common system settings shared across all hosts

## Concrete Systems (`systems/`)

Each directory in `systems/` represents a concrete deployment - a specific combination of hardware, host type, and users with a unique hostname.

Example: `systems/jaro/` combines:
- Hardware: `brojo-thinkpad-p14s-gen2`
- Host type: `default` (productivity)
- Users: `brojo`
- Hostname: `jaro`

## Benefits of This Architecture

### Modularity
- Hardware configurations are hardware-only
- Host types are reusable across different hardware
- Users are portable across different systems

### Reusability
- Want another productivity system? Just create a new system with `default.nix` host type
- Need a server? Create `server.nix` host type and reuse it across multiple machines
- User moves to a new machine? Import their user configuration

### Maintainability
- Changes to hardware affect only hardware layer
- Changes to host functionality affect only host type
- User preference changes affect only user layer

### Scalability
- Easy to add new host types (web server, database server, etc.)
- Easy to add new users
- Easy to support new hardware configurations

## Usage Examples

### Creating a New System
1. Add hardware configuration to `lib/hardware/machines/` (if new hardware)
2. Create or reuse host type in `lib/hosts/`
3. Create system configuration in `systems/new-hostname/`
4. Add to `flake.nix` nixosConfigurations

### Adding a New Host Type
```nix
# lib/hosts/server.nix
{ config, lib, pkgs, hostname ? "server", ... }:
{
  imports = [ ../system/base.nix ];
  networking.hostName = hostname;
  # Server-specific configuration...
}
```

### Multiple Instances of Same Host Type
```nix
# flake.nix
nixosConfigurations = {
  game-server-1 = import ./systems/game-server-1 inputs;
  game-server-2 = import ./systems/game-server-2 inputs;
};
```

Both can use the same `lib/hosts/game-server.nix` but with different hostnames.

## Building and Deploying

```bash
# Build the system
sudo nixos-rebuild switch --flake .#jaro

# Test the configuration
nixos-rebuild build --flake .#jaro
```

## Directory Structure
```
.
├── flake.nix                    # Main flake configuration
├── systems/                    # Concrete system deployments
│   └── jaro/                   # Specific system instance
├── lib/
│   ├── hardware/               # Hardware configurations
│   │   ├── machines/           # Specific hardware configs
│   │   └── profiles/           # Reusable hardware profiles
│   ├── hosts/                  # Host type configurations
│   ├── users/                  # User configurations
│   └── system/                 # Shared system configurations
└── README.md                   # This file
```