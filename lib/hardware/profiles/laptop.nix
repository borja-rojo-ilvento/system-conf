{ config, lib, pkgs, ... }:

{
  # Generic laptop hardware settings
  hardware = {
    enableAllFirmware = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  # Power management for laptop
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  # Laptop-specific power/lid behavior
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "suspend";
    extraConfig = ''
      HandlePowerKey=suspend
    '';
  };

  # Enable bluetooth manager
  services.blueman.enable = true;
}