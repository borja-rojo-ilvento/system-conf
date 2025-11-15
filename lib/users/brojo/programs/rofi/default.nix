{ config, pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    font = "JetBrainsMono Nerd Font 12";
    terminal = "ghostty";
    location = "center";
    cycle = true;
    theme = ./theme.rasi;
    modes = [ "drun" "run" "window" ];
    extraConfig = {
      show-icons = true;
      drun-display-format = "{icon} {name}";
      display-drun = "   ";
      display-run = "   ";
      display-window = "   ";
      display-ssh = "   ";
    };
  };

  xdg.configFile."rofi/theme.rasi".source = ./theme.rasi;

  home.packages = with pkgs; [
    rofi
    papirus-icon-theme
  ];
}
