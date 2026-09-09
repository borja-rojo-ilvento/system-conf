{ disko, ... }:

{
  imports = [
    disko.nixosModules.disko
    ./disk-config.nix
    ./hardware-configuration.nix
  ];

  hardware.enableAllFirmware = true;
}
