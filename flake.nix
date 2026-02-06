{
  description = "Personal NixOS system configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    backlog-md = {
      url = "github:MrLesk/Backlog.md";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      backlog-md,
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
        everest = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit (inputs) nixos-hardware home-manager;
          };
          modules = [
            # Hardware configuration
            ./lib/hardware/machines/bung-box

            # Host type configuration
            (import ./lib/hosts { hostname = "everest"; })

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

      devShells = {
        x86_64-linux =
          let
            pkgsUnfree = import nixpkgs {
              system = "x86_64-linux";
              config = {
                allowUnfree = true;
              };
            };
          in
          {
            default = pkgsUnfree.mkShell {
              buildInputs = with pkgsUnfree; [
                git
                nix
                nixos-rebuild
                claude-code
                backlog-md.packages.x86_64-linux.default
              ];

              shellHook = ''
                echo "Entering NixOS configuration development environment"
                echo "Available tools: git, nix, nixos-rebuild, backlog-md"
              '';
            };
          };
      };
    };
}
