{ pkgs, ... }:
{
  # Generic, compositor-agnostic power-management user tooling. Anything that
  # ties screen lock or idle handling to Hyprland (swaylock, hypridle, the
  # power-keybinds fragment) lives in the sequestered Hyprland tree under
  # ./hyprland/idle-lock.nix.

  home.packages = with pkgs; [
    # Power and battery monitoring
    upower
    acpi

    # Brightness control
    brightnessctl

    # Performance monitoring and profiling
    htop
    iotop
    powertop
    lm_sensors

    # System information
    fastfetch
    lsof

    # Systemd tools
    systemd
  ];

  # ── Anex: prior approaches and why they were dropped ────────────────────────
  #
  # Tried: programs.swaylock, services.hypridle, and a Hyprland
  # power-keybinds.conf home.file declared from this generic file.
  # Moved to lib/users/brojo/programs/hyprland/idle-lock.nix because they are
  # tightly coupled to a specific compositor (Hyprland) and the active session
  # on every host is currently Plasma 6, which uses kscreenlocker / KIdleTime.
  # Keeping them here pulled swaylock/hypridle into every user environment for
  # no benefit.
}
