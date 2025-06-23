{
  description = "Personal NixOS system configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "github:borja-rojo-ilvento/nixos-hardware?ref=lenovo-thinkpad-p14s-intel-gen2";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        jaro = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit (inputs) nixos-hardware home-manager;
          };
          modules = [
            # Hardware configuration
            ./lib/hardware/machines/brojo-thinkpad-p14s-gen2

            # Host type configuration
            (import ./lib/hosts { hostname = "jaro"; })

            # Home manager
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.brojo = import ./lib/users/brojo/home.nix;
            }
          ];
        };
      };
    };
}
