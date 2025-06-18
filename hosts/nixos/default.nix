{ lib, ... }:
{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ./lenovo-thinkpad-p14s-gen2.nix
  ];
}
