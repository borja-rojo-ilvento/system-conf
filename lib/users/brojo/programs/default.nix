{ pkgs, ... }:
{
  imports = [
    ./obs.nix
    ./steam.nix
    ./neovim.nix
    ./discord.nix
    ./dunst.nix
    ./rofi
    ./hyprland
    ./theming.nix
    ./power-management.nix
    ./development.nix
    ./input-method.nix
  ];

  config = {
    home.packages = with pkgs; [
      mangohud
      protonup-qt
      lutris
      bottles
      heroic
      nemo
      gvfs
    ];

    programs = {
      git = {
        enable = true;
        userName = "Borja Rojo Ilvento";
        userEmail = "borja.rojo@gmail.com";
      };

      zsh = {
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
        initContent = ''
          fpath=(/home/brojo/.zsh/completions $fpath)
          autoload -Uz compinit && compinit
        '';
      };

      direnv = {
        enable = true;
        nix-direnv.enable = true;
        enableZshIntegration = true;
      };
    };
  };
}
