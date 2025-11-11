{ pkgs, ... }:
{
  imports = [
    ./obs.nix
    ./steam.nix
    ./neovim.nix
    ./discord.nix
    ./dunst.nix
    ./hyprland
  ];

  config = {
    home.packages = with pkgs; [
      mangohud
      protonup-qt
      lutris
      bottles
      heroic
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
        initExtra = ''
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
