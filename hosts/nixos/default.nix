{ nixos-hardware, ... }:
{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    (import ./lenovo-thinkpad-p14s-gen2.nix { inherit nixos-hardware; })
  ];
}