{
  nixpkgs,
  nixos-hardware,
  home-manager,
  brojo,
  ...
}:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {
    inherit nixos-hardware home-manager;
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
      home-manager.users.brojo = brojo.nixosModules.default;
    }
  ];
}
