{ config, lib, pkgs, ... }:
{
  # Systemd-level power management (suspend/resume hooks, runtime PM frame).
  powerManagement.enable = true;

  # Power profiles daemon for switching between performance/balanced/power-saver.
  services.power-profiles-daemon.enable = true;

  # Sleep and suspend behavior. Hardware/host modules may override per-machine.
  services.logind.settings = {
    Login = {
      IdleAction = lib.mkDefault "suspend";
      IdleActionSec = lib.mkDefault 600;
      HandleLidSwitch = lib.mkDefault "suspend";
      HandleLidSwitchExternalPower = lib.mkDefault "suspend";
      HandleLidSwitchDocked = lib.mkDefault "ignore";
      HandlePowerKey = lib.mkDefault "poweroff";
      HandlePowerKeyLongPress = lib.mkDefault "ignore";
      HandleCriticalPower = lib.mkDefault "PowerOff";
    };
  };

  # Thermald for thermal management (Intel processors).
  services.thermald.enable = true;

  # Display-manager log capture (useful when debugging suspend → DM crashes).
  services.displayManager.logToFile = true;

  # X server DPMS (only consulted when an X session is in play).
  services.xserver.serverFlagsSection = ''
    Option "BlankTime" "0"
    Option "StandbyTime" "0"
    Option "SuspendTime" "0"
    Option "OffTime" "0"
  '';

  # System packages for power management
  environment.systemPackages = with pkgs; [
    power-profiles-daemon
    upower
    acpi
    brightnessctl
    playerctl
  ];

  # Polkit rules for power management without password prompt
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if ((action.id == "org.freedesktop.login1.power-off" ||
           action.id == "org.freedesktop.login1.power-off-multiple-sessions" ||
           action.id == "org.freedesktop.login1.reboot" ||
           action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
           action.id == "org.freedesktop.login1.suspend" ||
           action.id == "org.freedesktop.login1.suspend-multiple-sessions" ||
           action.id == "org.freedesktop.login1.hibernate" ||
           action.id == "org.freedesktop.login1.hibernate-multiple-sessions" ||
           action.id == "org.freedesktop.upower.hibernate" ||
           action.id == "org.freedesktop.upower.suspend") &&
          subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  # ── Anex: prior approaches and why they were dropped ────────────────────────
  #
  # Tried: powerManagement.cpuFreqGovernor = "schedutil".
  # Removed because power-profiles-daemon (enabled above) takes ownership of the
  # CPU governor at runtime based on the active profile, so this setting was
  # only honored briefly at boot before being overridden. Misleading rather than
  # harmful.
  #
  # Tried: services.acpid.enable = true.
  # Removed because systemd-logind handles lid/power/sleep button events
  # directly via /dev/input → uinput; acpid is a legacy daemon for systems
  # without logind and only created an extra subscriber to the same events.
  #
  # Tried: services.cpupower-gui.enable = false (a pseudo-toggle).
  # Removed because Nix already defaults disabled options to off; explicit
  # `= false` was just noise.
}
