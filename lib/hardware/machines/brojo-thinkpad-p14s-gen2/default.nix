{ inputs, ... }:

{
  imports = [
    # Machine-specific hardware configuration
    ./hardware-configuration.nix
    ./lenovo-thinkpad-p14s-gen2.nix
    
    # Hardware profiles
    ../../profiles/laptop.nix
    ../../profiles/desktop-plasma.nix
    
    # Base system configuration
    ../../../system/base.nix
  ];

  # Machine-specific settings
  networking.hostName = "nixos";

  # Machine-specific services and optimizations
  services.udev.packages = [ inputs.nixpkgs.legacyPackages.x86_64-linux.ledger-udev-rules ];
  
  # Gaming configuration
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Performance optimization for OBS
  systemd.services.obs = {
    serviceConfig = {
      CPUAffinity = "6 7";  # Dedicating threads 6-7 (last physical core)
      Nice = -10;           # Higher priority but not maximum
    };
  };

  # User configuration - machine specific
  users.users.brojo = {
    isNormalUser = true;
    description = "brojo";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    packages = with inputs.nixpkgs.legacyPackages.x86_64-linux; [
      kdePackages.kate
    ];
  };
}