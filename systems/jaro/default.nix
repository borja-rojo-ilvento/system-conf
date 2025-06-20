{
  nixpkgs,
  nixos-hardware,
  home-manager,
  claude-desktop,
  ...
}:

nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {
    inherit nixos-hardware home-manager claude-desktop;
    hostname = "jaro";
  };
  modules = [
    # Hardware configuration
    ../../lib/hardware/machines/brojo-thinkpad-p14s-gen2

    # Host type configuration
    ../../lib/hosts/default.nix

    # Home manager
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.brojo = import ../../lib/users/brojo/home.nix;
      home-manager.extraSpecialArgs = {
        inherit claude-desktop;
      };
    }
  ];
}

