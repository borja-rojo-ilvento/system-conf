# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  boot.blacklistedKernelModules = [ "nouveau" ];

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    enableAllFirmware = true;
    nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
    };
    
    graphics = { enable = true; enable32Bit = true; };
    bluetooth = { enable = true; powerOnBoot = true; };
  };
}

