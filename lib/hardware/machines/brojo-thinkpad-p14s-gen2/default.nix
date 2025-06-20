{ config, lib, pkgs, ... }:

{
  imports = [
    # Machine-specific hardware configuration
    ./hardware-configuration.nix
    ./lenovo-thinkpad-p14s-gen2.nix
    
    # Hardware profiles
    ../../profiles/laptop.nix
    ../../profiles/desktop-plasma.nix
  ];
}