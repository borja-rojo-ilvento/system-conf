# Hyprland Implementation Milestone

## Overview
Implement a complete Hyprland-based desktop environment for the jaro system (ThinkPad P14s Gen2). This milestone encompasses the full stack required to move from KDE Plasma 6 to a modern, customizable Hyprland compositor with supporting services and UI components.

---

## 1. Core Philosophy & Design

### Hyprland Principles
- **100% independent dynamic tiling Wayland compositor** - no reliance on wlroots
- **Visual excellence**: Gradient borders, blur effects, smooth animations
- **Dynamic tiling**: Binary tree structure (dwindle layout) with automatic window arrangement
- **Extensive customization**: Single configuration file (hyprland.conf) with socket-based IPC
- **Modern stack**: Built on Wayland with active development and frequent updates

### Differentiation Strategy
- Prioritize innovation and visual appeal over compatibility
- Accept assembly work vs. pre-integrated desktop environment
- Leverage dynamic tiling to reduce manual window management overhead
- Target early-adopter community with focus on customization

---

## 2. Essential System Services

### Notification Daemon (Required)
**Decision Framework**: Choose one implementation based on needs
- **dunst** (recommended): Lightweight, highly customizable, widely used
- **mako**: Simple and reliable alternative
- **fnott**: Another lightweight option
- **swaync**: Feature-rich with history and control center

**Implementation**:
- D-Bus auto-activated when notifications emitted
- Integrate with Hyprland keybindings for notification control

### Polkit Authentication Agent (Strongly Recommended)
**Purpose**: Privilege escalation for system administration tasks
- Installing packages via pacman/nix
- Changing settings requiring elevation
- System configuration dialogs

**Recommended**: `hyprpolkitagent` (first-party Hyprland option, optimized for environment)

**Fallback**: Standard polkit agents work but less optimized

### XDG Desktop Portal (Critical)
**Purpose**: Cross-application functionality framework
- File pickers and file dialogs
- Screen sharing (region, window, or full screen)
- Global shortcuts support
- Screenshotting utilities

**Hyprland-Specific Implementation**:
- `xdg-desktop-portal-hyprland`: Enhanced portal with extra functionality
- Graphical picker utility for screen sharing
- Support for region and window-specific sharing (not just fullscreen)
- Requires `xdg-desktop-portal` as dependency

### D-Bus Session Management
- Session D-Bus daemon required for service activation
- Must be verified and configured in Hyprland environment
- Critical for notification daemon and polkit functionality

### Display Configuration
**Primary Tool**: `nwg-displays`
- GUI application for monitor arrangement
- Wayland-native, works standalone
- Controls: resolution, refresh rate, positioning, scaling

**Configuration**: Manual settings in `hyprland.conf` [Monitor] section

### Audio Management Stack
**Recommended**: Pipewire/Wireplumber (modern approach)
- `wpctl` commands for volume control via keybindings
- Support for XF86AudioRaiseVolume/LowerVolume key bindings
- Better latency and feature set than ALSA
- `playerctl` for multimedia control (play/pause/next/previous)

**Alternative**: ALSA with `amixer` commands (older but compatible)

---

## 3. UI Component Stack

### Application Launcher
**Decision Framework**: Balance customization vs. performance
- **Hyprlauncher**: Official first-party Hyprland launcher, multipurpose, tight integration
- **Wofi**: GTK-based, highly customizable, Wayland-native (note: potential DPI scaling issues)
- **Fuzzel**: Lightweight, good Hyprland integration, similar to Rofi's drun mode
- **Tofi**: Extremely fast, minimal overhead, claims single-frame on-screen time
- **Anyrun**: Wayland-native, krunner-like runner with customization focus
- **Rofi**: X11-native historically, Wayland support added as of 2025

**Recommendation**: Wofi or Fuzzel for community standard; Hyprlauncher for tighter integration

### Status Bar
**Primary Option**: Waybar
- Most popular and widely adopted
- Extensive customization and module support
- Actively maintained with excellent documentation
- Good Hyprland integration

**Hyprland-Specific Alternatives**:
- **HyprPanel**: Built specifically for Hyprland, extensive customization, context menus
- **Quickshell**: Modern open-source Waybar replacement, gaining adoption

**Lightweight Options**:
- **Eww**: Widget framework on GTK, can serve as status bar
- **Ironbar**: Very customizable with GUI components
- **Nwg-panel**: GTK3-based with graphical configuration
- **Gbar**: GTK3-based, fast and efficient
- **Ashell**: Ready out-of-box with essential modules (limited customization)

**Framework Approaches**:
- **Ags**: Customizable shell framework specifically for Hyprland
- **Fabric**: Python widgets framework for Wayland and X11

**Recommendation**: Waybar for maximum flexibility and community support; HyprPanel for Hyprland-specific integration

### Additional UI Components
- **Clipboard Manager**: Multiple options available in Hyprland wiki (essential for practical multi-app use)
- **File Manager**: Any Wayland-compatible option; lightweight variants recommended for minimal overhead
- **Terminal Emulator**: Most modern terminals support Wayland; popular choices: Kitty (GPU acceleration), Alacritty, foot

---

## 4. Hyprland-Specific Ecosystem Tools

### First-Party Tools
- **hyprpaper**: Wallpaper management and configuration
- **hyprpicker**: Color picker utility for design workflows
- **hypridle**: Idle state management and automation
- **hyprlock**: Lock screen implementation

### System Control Scripts
- Screenshot utilities via keybindings
- Brightness control scripts
- Display settings management scripts
- Location: `config/hypr/scripts/` directory structure
- Manually scripted (no unified settings dialog like KDE)

---

## 5. NixOS Integration & Configuration

### NixOS Advantages
- Strong built-in Hyprland support (one of earliest platforms)
- Simple enable: `programs.hyprland.enable = true;`
- NixOS module handles critical dependencies (polkit, portals, graphics drivers)
- NixOS 24.11+ includes UWSM (Universal Wayland Session Manager) support

### Architecture Considerations
- Leverage NixOS module system for Hyprland configuration
- Use `specialArgs` pattern for passing hostname and flake inputs
- Consider UWSM for robust session management
- Test Mesa/graphics driver compatibility with laptop GPU (ThinkPad P14s Gen2)

### Known NixOS Hyprland Issues
- Mesa version mismatches can cause performance problems
- Electron-based apps (Vesktop, VSCodium) may have flickering issues
- Wayland adoption gaps for specialized software (e.g., Plover stenography)

---

## 6. Implementation Phases

### Phase 1: Core Services Foundation
- [ ] Enable Hyprland via NixOS module
- [ ] Configure D-Bus session management
- [ ] Install and configure notification daemon (dunst recommended)
- [ ] Install and configure hyprpolkitagent
- [ ] Set up xdg-desktop-portal and xdg-desktop-portal-hyprland
- [ ] Verify all services start correctly

### Phase 2: Audio & System Integration
- [ ] Verify Pipewire/Wireplumber installation
- [ ] Configure wpctl-based volume control
- [ ] Set up XF86Audio keybindings integration
- [ ] Configure playerctl for multimedia control
- [ ] Test audio device switching

### Phase 3: Core Hyprland Configuration
- [ ] Create `lib/system/hyprland/default.nix` base configuration
- [ ] Configure monitor settings ([Monitor] section) for laptop display
- [ ] Set up input handling (trackpad, keyboard configuration)
- [ ] Configure keybindings for core operations
- [ ] Implement dwindle layout settings
- [ ] Configure visual effects (borders, blur, animations)

### Phase 4: UI Component Stack
- [ ] Select and implement application launcher (Wofi or Fuzzel recommended)
- [ ] Install and configure Waybar status bar
- [ ] Configure Waybar modules for system information
- [ ] Set up clipboard manager
- [ ] Configure terminal emulator (Kitty/Alacritty/foot)
- [ ] Configure file manager for Wayland

### Phase 5: Hyprland Ecosystem Tools
- [ ] Install hyprpaper and configure wallpaper management
- [ ] Install hyprpicker for color selection utilities
- [ ] Install hypridle and configure idle state management
- [ ] Install hyprlock and configure lock screen
- [ ] Create system control scripts directory structure

### Phase 6: System Scripts & Automation
- [ ] Create screenshot utility scripts
- [ ] Create brightness control scripts
- [ ] Create display settings scripts
- [ ] Integrate scripts with keybindings
- [ ] Set up notification integration for feedback

### Phase 7: Testing & Optimization
- [ ] Build configuration without switching (nixos-rebuild build)
- [ ] Verify all services start correctly
- [ ] Test graphics performance on laptop hardware
- [ ] Test audio functionality with various applications
- [ ] Test screen sharing and portal functionality
- [ ] Verify polkit authentication dialogs appear correctly
- [ ] Performance benchmark vs. KDE Plasma

### Phase 8: Hardware-Specific Tuning
- [ ] Configure ThinkPad-specific power management
- [ ] Set up battery status monitoring in status bar
- [ ] Configure trackpad gestures and behavior
- [ ] Test with dual-monitor setup (if applicable)
- [ ] Address Mesa/driver compatibility issues if present

### Phase 9: Migration & Documentation
- [ ] Create comprehensive Hyprland configuration documentation
- [ ] Document keybindings and custom scripts
- [ ] Create troubleshooting guide for common issues
- [ ] Document service startup dependencies
- [ ] Switch from KDE Plasma to Hyprland
- [ ] Monitor for post-migration issues

---

## 7. Community & Support Context

### Software Quality
**Strengths**:
- Highly appreciated for customization and visual appeal
- Active development with frequent improvements
- Modern feature set and strong performance
- Strong adoption in early-adopter communities

**Known Concerns**:
- Some documented community culture issues (2023-2024)
- Project leadership has responded with detailed statements and Code of Conduct
- Recommendation: Focus on software quality; community engagement optional

### Practical Approach
- Software is stable and widely used despite community concerns
- Consider leveraging NixOS integration for proven configuration patterns
- Join NixOS Hyprland communities if community support needed (generally positive environment)

---

## 8. Target System Specifications

### Hardware Context
- **Device**: ThinkPad P14s Gen2 (laptop)
- **Current OS**: NixOS with KDE Plasma 6
- **User**: brojo
- **Architecture**: Modular NixOS flakes with hardware, host types, and user separation

### Configuration Goals
- Maintain modularity of existing NixOS architecture
- Create reusable Hyprland configuration for host type
- User-specific customizations in Home Manager
- Hardware-specific settings in laptop configuration

---

## 9. Success Criteria

- [ ] All core services (notification daemon, polkit, portals, D-Bus) functional
- [ ] Audio system fully operational with volume control keybindings
- [ ] Hyprland window manager starts and manages windows correctly
- [ ] Status bar displays system information accurately
- [ ] Application launcher opens and executes applications
- [ ] Screen sharing and file dialogs work via portal
- [ ] Lock screen functional with hypridle automation
- [ ] System performance meets or exceeds KDE Plasma
- [ ] All keybindings responsive and functional
- [ ] Laptop-specific hardware (trackpad, brightness) works correctly
- [ ] Configuration built and tested before switching
- [ ] Documentation complete for future maintenance

---

## 10. Implementation Notes

### Architecture Decisions
- Place core Hyprland configuration in `lib/system/hyprland/` for reuse
- User-specific customizations via Home Manager in `lib/users/brojo/`
- Keep laptop hardware-specific settings in `lib/hardware/`
- Use `specialArgs` pattern for hostname and flake input passing

### Testing Strategy
- Build configuration multiple times before switching
- Test each phase independently before proceeding
- Keep KDE Plasma functional as fallback during transition
- Document any workarounds for hardware-specific issues

### Documentation Requirements
- Comment all non-standard configuration choices
- Document keybinding structure for maintainability
- Maintain list of installed packages and their purposes
- Create troubleshooting section for common issues

---

## Research Sources

- Official Hyprland Wiki: https://wiki.hypr.land/
- NixOS Hyprland Support: https://wiki.nixos.org/wiki/Hyprland
- ArchWiki Hyprland: https://wiki.archlinux.org/title/Hyprland
- Community Awesome List: https://github.com/hyprland-community/awesome-hyprland
- GitHub Discussions: https://github.com/hyprwm/Hyprland/discussions
