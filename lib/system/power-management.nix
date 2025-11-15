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

  # Sleep and suspend behavior
  services.logind.extraConfig = ''
      # Screen blanking timeout (in seconds) - 5 minutes
      IdleAction=suspend
      IdleActionSec=600

      # Close lid action
      HandleLidSwitch=suspend
      HandleLidSwitchExternalPower=suspend
      HandleLidSwitchDocked=ignore

      # Power button action
      HandlePowerKey=poweroff
      HandlePowerKeyLongPress=ignore

      # Suspend on critical battery
      HandleCriticalPower=PowerOff
  '';

  # Automatic CPU frequency scaling
  services.cpupower-gui.enable = false; # We'll use power-profiles-daemon

  # ACPI event handling
  services.acpid.enable = true;

  # Thermald for thermal management (Intel processors)
  services.thermald.enable = true;

  # Screen blanking and DPMS
  services.xserver = {
    displayManager.job.logToFile = true;
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
