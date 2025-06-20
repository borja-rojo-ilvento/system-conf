{
  config,
  lib,
  pkgs,
  nixos-hardware,
  ...
}:

{
  imports = [
    # Machine-specific hardware configuration
    ./hardware-configuration.nix
    nixos-hardware.nixosModules.lenovo-thinkpad-p14s-intel-gen2
  ];

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
