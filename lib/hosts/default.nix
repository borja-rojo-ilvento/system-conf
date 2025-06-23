{
  hostname ? "default",
}:
{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Base system configuration
    ../system/base.nix
  ];

  # Host identification
  networking.hostName = hostname;

  # Productivity host services
  services.udev.packages = [ pkgs.ledger-udev-rules ];

  # Gaming configuration
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Performance optimization for OBS
  systemd.services.obs = {
    serviceConfig = {
      CPUAffinity = "6 7"; # Dedicating threads 6-7 (last physical core)
      Nice = -10; # Higher priority but not maximum
    };
  };

  # Users configuration
  users.users.brojo = {
    isNormalUser = true;
    description = "brojo";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
}
