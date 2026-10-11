{ pkgs, ... }:
{
  imports = [
    ./obs.nix
    ./neovim.nix
    ./discord.nix
    # ./dunst.nix, ./rofi and ./hyprland are intentionally not imported — the
    # active session is Plasma 6, which provides notifications + KRunner. See
    # each module's sequestered header for revival steps.
    ./power-management.nix
    ./development.nix
    ./input-method.nix
    ./ghostty.nix
  ];

  config = {
    home.packages = with pkgs; [
      mangohud
      protonup-qt
      heroic
      nemo
      gvfs
    ];

    programs = {
      git = {
        enable = true;
        settings = {
          user = {
            name = "Borja Rojo Ilvento";
            email = "borja.rojo@gmail.com";
          };
        };
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
        # initContent = ''
        #   fpath=(/home/brojo/.zsh/completions $fpath)
        #   autoload -Uz compinit && compinit
        # '';
      };

      direnv = {
        enable = true;
        nix-direnv.enable = true;
        enableZshIntegration = true;
      };
    };
  };
}
