{
  pkgs,
  lib,
  dotfiles,
  ...
}:
{
  imports = [
    ./programs
    dotfiles.nixosModules.default
  ];

  home.packages = with pkgs; [
    nix-search-cli
    firefox
    clang
    gnumake
    cargo
    go
    nodejs-slim
    wget
    git
    code-cursor
    discord
    zoom-us
    xwayland
    zoxide
    ripgrep
    flameshot
    fzf
    ledger-live-desktop
    ledger-udev-rules
    kdePackages.kscreen
    home-manager
    nmap
    arp-scan
    google-chrome
    stremio
    obsidian
    minecraft
    jdk
    devbox
    ghostty
    stow
    pkg-config
    openssl
    nix-direnv
    oh-my-zsh
    tree
    ani-cli
    claude-code
  ];

  programs.git = {
    enable = true;
    userName = "Borja Rojo Ilvento";
    userEmail = "borja.rojo@gmail.com";
  };
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "alanpeabody";
      plugins = [
        "git"
        "fzf"
        "zoxide"
        "direnv"
      ];
    };
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  home.stateVersion = "24.11";
}
