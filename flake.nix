{
  description = "Personal NixOS system configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    akirak-flake-templates = {
      url = "github:akirak/flake-templates";
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
            (import ./lib/hosts/desktop.nix {
              hostname = "jaro";
              localIP = "192.168.0.51";
            })

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
            (import ./lib/hosts/desktop.nix {
              hostname = "ever";
              localIP = "192.168.0.52";
            })

            # Home manager
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.brojo = import ./lib/users/brojo/home.nix;
            }
          ];
        };
        fuji = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit (inputs) nixos-hardware home-manager;
          };
          modules = [
            # Hardware configuration — directory named after the physical
            # machine, not the host. See CLAUDE.md.
            ./lib/hardware/machines/dell-mini-001

            # Host type configuration — headless server flavour.
            (import ./lib/hosts/server.nix {
              hostname = "fuji";
              localIP = "192.168.0.50";
              ethInterface = "enp1s0";
            })

            # Services running on this host
            ./lib/services/gitea.nix

            # Home manager — same brojo user as desktop hosts. Will pull GUI
            # programs into the closure; harmless on headless (see
            # lib/hosts/server.nix Anex).
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.brojo = import ./lib/users/brojo/home.nix;
            }
          ];
        };

        # Reusable installer ISO. Built once, written to USB, used to bring
        # any new machine to a state where `nixos-anywhere` can kexec into
        # it. Intentionally minimal: no home-manager, no brojo desktop
        # closure, no lib/hosts/* — keeps `nix flake check` fast and means
        # one ISO covers every future install.
        installer = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (
              { modulesPath, ... }:
              {
                imports = [
                  "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
                ];

                services.openssh = {
                  enable = true;
                  settings.PermitRootLogin = "prohibit-password";
                };

                users.users.root.openssh.authorizedKeys.keys = [
                  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO//ZN3LvwD7awHobeXg4m89kCP/KJuLvP46OAyxiM8x borja.rojo@gmail.com"
                ];

                # Networking comes from installation-cd-minimal.nix, which
                # enables NetworkManager + nm-online and brings up ethernet
                # via DHCP at boot. Explicitly setting networking.useDHCP
                # here conflicts with NetworkManager's default.
              }
            )
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
                lighttpd
                nmap
                arp-scan
                iproute2
                openssh
              ];

              shellHook = ''
                echo "Entering NixOS configuration development environment"
                echo "Available tools: git, nix, nixos-rebuild"
              '';
            };
          };
      };

      templates = import ./templates // inputs.akirak-flake-templates.templates;

    };
}
