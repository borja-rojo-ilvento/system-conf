{ config, lib, pkgs, ... }:
{
  # Power management configuration
  powerManagement = {
    enable = true;
    # Systemd will handle power management
    cpuFreqGovernor = "schedutil";
  };

  # Power profiles daemon for switching between performance/balanced/power-saver
  services.power-profiles-daemon.enable = true;

  # TLP for advanced battery management (alternative to power-profiles-daemon)
  # services.tlp.enable = true;

  # Sleep and suspend behavior (with defaults that can be overridden by hardware)
  services.logind.settings = {
    Login = {
      # Screen blanking timeout (in seconds) - 10 minutes
      IdleAction = lib.mkDefault "suspend";
      IdleActionSec = lib.mkDefault 600;
      # Close lid action (hardware-specific settings will override)
      HandleLidSwitch = lib.mkDefault "suspend";
      HandleLidSwitchExternalPower = lib.mkDefault "suspend";
      HandleLidSwitchDocked = lib.mkDefault "ignore";
      # Power button action (hardware-specific settings will override)
      HandlePowerKey = lib.mkDefault "poweroff";
      HandlePowerKeyLongPress = lib.mkDefault "ignore";
      # Suspend on critical battery
      HandleCriticalPower = lib.mkDefault "PowerOff";
    };
  };

  # Automatic CPU frequency scaling
  services.cpupower-gui.enable = false; # We'll use power-profiles-daemon

  # ACPI event handling
  services.acpid.enable = true;

  # Thermald for thermal management (Intel processors)
  services.thermald.enable = true;

  # Screen blanking and DPMS
  services.displayManager.logToFile = true;

  # X Server DPMS configuration (if X is used)
  services.xserver = {
    # DPMS (Display Power Management Signaling)
    serverFlagsSection = ''
      Option "BlankTime" "0"
      Option "StandbyTime" "0"
      Option "SuspendTime" "0"
      Option "OffTime" "0"
    '';
  };

  # System packages for power management
  environment.systemPackages = with pkgs; [
    power-profiles-daemon
    upower
    acpi
    acpid
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
}
