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
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems f;
    in
    forAllSystems (system: 
      let
        pkgs = nixpkgs.legacyPackages.${system};
        homeConfig = import ./home.nix { inherit pkgs dotfiles; };
      in
      {
        nixosModules.default = homeConfig;
        
        homeConfigurations.brojo = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ homeConfig ];
        };
      }
    );
}
