# TODO Items and Notes

## Future Improvements

### Hostname Parameter Simplification
**Current Issue**: The `specialArgs` in `systems/jaro/default.nix` requires explicitly inheriting all flake inputs (`nixos-hardware`, `home-manager`, `claude-desktop`) just to pass the `hostname` parameter.

**Motivation**: When you add `specialArgs` to pass custom parameters like `hostname`, NixOS doesn't automatically merge the function inputs with `specialArgs`. This forces us to explicitly list all the inherited attributes that modules might need.

**Current Implementation**:
```nix
specialArgs = {
  inherit nixos-hardware home-manager claude-desktop;
  hostname = "jaro";
};
```

**Alternative Approaches to Consider**:

1. **Module Configuration Approach** (Recommended):
   ```nix
   modules = [
     ../../lib/hosts/default.nix
     { networking.hostName = "jaro"; }
     # other modules...
   ];
   ```
   - Pros: No need for specialArgs, cleaner separation
   - Cons: Hostname setting is separated from other host-specific config

2. **Module Options Approach**:
   ```nix
   # In lib/hosts/default.nix
   options.networking.hostName = lib.mkOption {
     type = lib.types.str;
     default = "default";
   };
   ```
   - Pros: Proper NixOS option system integration
   - Cons: More complex for simple hostname setting

**Learning Notes**:
- `specialArgs` is for passing custom parameters to modules that aren't part of the standard NixOS module system
- When using `specialArgs`, you must explicitly include all arguments that modules expect
- The NixOS module system has built-in ways to handle configuration that might be cleaner than custom parameters
- Consider whether a parameter truly needs to be "special" or if it can be handled through normal module configuration

**Decision**: Keep current implementation for now, but consider refactoring to approach #1 when doing major configuration changes.

## Architecture Notes

### Module System Understanding
- NixOS modules receive standard arguments: `{ config, lib, pkgs, ... }`
- Custom arguments must be passed via `specialArgs` or `extraSpecialArgs`
- `specialArgs` affects all modules in the configuration
- `extraSpecialArgs` (used in home-manager) affects only that specific module system

### Future Host Types
When adding new host types (server.nix, media-server.nix, etc.), consider:
- Whether they need custom parameters like hostname
- If they can use standard module configuration instead of specialArgs
- How to maintain consistency across different host types

## Code Quality Improvements

### Potential Refactoring Targets
- [ ] Simplify hostname parameter passing
- [ ] Evaluate which services truly belong in host types vs hardware profiles
- [ ] Consider splitting large host configurations into smaller, composable modules
- [ ] Add validation for required parameters in host modules

### Documentation
- [ ] Add inline comments explaining parameter passing in complex modules
- [ ] Document the relationship between specialArgs and module parameters
- [ ] Create examples of different ways to pass configuration to modules