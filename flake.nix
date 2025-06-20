{
  description = "Personal NixOS system configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "github:borja-rojo-ilvento/nixos-hardware?ref=lenovo-thinkpad-p14s-intel-gen2";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-desktop = {
      url = "github:k3d3/claude-desktop-linux-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, ... }@inputs:
    {
      nixosConfigurations = {
        jaro = import ./systems/jaro inputs;
      };
    };
}
