{ config, pkgs, claude-desktop, ... }:
let
  neovimConfig = {
    enable = true;
    extraPackages = with pkgs; [
      python3
      git
      gnumake
      rustup
      unzip
      lua51Packages.lua
      luarocks
      ripgrep
      fd
      clang
      tree-sitter
      lua-language-server
      rust-analyzer
      ruff
      nil
      fzf
      claude-code
    ];
    # plugins = with pkgs.vimPlugins; [
    #   lazy-nvim
    # ];
    # extraConfig = ''
    #   require("config.lazy")
    #   '';
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
in
  {
  imports = [
    ./programs/obs.nix
    ./programs/steam.nix
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
    windsurf
    discord
    zoom-us
    xwayland
    zoxide
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
    claude-desktop.packages.${pkgs.system}.claude-desktop-with-fhs
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

  programs.neovim = neovimConfig;
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

  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };

  # Uncomment if you need to set up kwallet configuration
  # xdg.configFile."kwalletrc".text = ''
  #   [Wallet]
  #   Enabled=true
  #   First Use=false
  #   Use One Wallet=true
  #   Default Wallet=kdewallet
  #   Local Wallet=kdewallet
  #
  #   [Auto Allow]
  #   Enabled=true
  #   Idle Timeout=0
  #   Allowed Applications=*
  #
  #   [Auto Close]
  #   Enabled=false
  #
  #   [Auto Deny]
  #   Enabled=false
  #
  #   [General]
  #   CloseWhenNoWindow=false
  #   ShowSystemTray=false
  #
  #   [Passwords]
  #   Store New Passwords=true
  #
  #   [Auto Unlock]
  #   Enabled=true
  #
  #   [Migration]
  #   alreadyMigrated=true
  # '';

  home.stateVersion = "24.11";
}
