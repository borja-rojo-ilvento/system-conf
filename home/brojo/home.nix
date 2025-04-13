{ config, pkgs, claude-desktop, ... }:
let
neovimConfig = {
  enable = true;
  extraPackages = with pkgs; [
    python3
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
  home.packages = with pkgs; [
    nix-search-cli
      firefox
      clang
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
      ];

  programs.neovim = neovimConfig;
  programs.git = {
    enable = true;
    userName = "Borja Rojo Ilvento";
    userEmail = "borja.rojo@gmail.com";
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
