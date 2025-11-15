{ config, pkgs, ... }:
let
  theme = builtins.readFile ./theme.rasi;
in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    font = "JetBrainsMono Nerd Font 12";
    terminal = "ghostty";
    location = "center";
    cycle = true;
    theme = theme;
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

  home.packages = with pkgs; [
    rofi
    papirus-icon-theme
  ];
}
