{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    claude-code
  ];

  # Cretae a nix expression to grab my dotfiles and download them, and call stow, then add that here as a dependency
}
