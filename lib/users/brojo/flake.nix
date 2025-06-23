{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    dotfiles.url = "github:borja-rojo-ilvento/dotfiles";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      dotfiles,
      ...
    }@inputs:
    let
      homeConfig = import ./home.nix inputs;
    in
    {
      nixosModules.default = homeConfig;

      homeConfigurations.brojo = home-manager.lib.homeConfigurations {
        inherit nixpkgs;
        modules = [ homeConfig ];
      };
    };
}
