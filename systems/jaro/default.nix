{
  # nixpkgs,
  nixos-hardware,
  home-manager,
  dotfiles,
  ...
}:
{
  system = "x86_64-linux";
  specialArgs = {
    inherit nixos-hardware home-manager dotfiles;
  };
  modules = [
    # Hardware configuration
    ../../lib/hardware/machines/brojo-thinkpad-p14s-gen2

    # Host type configuration
    (import ../../lib/hosts { hostname = "jaro"; })

    # Home manager
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.brojo = import ../../lib/users/brojo/home.nix;
      home-manager.extraSpecialArgs = {
        inherit dotfiles;
      };
    }
  ];
}
