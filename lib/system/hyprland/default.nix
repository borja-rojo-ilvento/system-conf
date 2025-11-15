{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Enable Hyprland window manager at system level
  programs.hyprland = {
    enable = true;
  };

  # Required fonts for Hyprland
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Essential packages for Hyprland functionality
  environment.systemPackages = with pkgs; [
    hyprland
    kdePackages.kwallet
    kdePackages.kwallet-pam
    kdePackages.kwalletmanager
  ];

  # PAM integration for automatic KWallet unlock
  security.pam.services = {
    login.enableKwallet = true;
  };
}
