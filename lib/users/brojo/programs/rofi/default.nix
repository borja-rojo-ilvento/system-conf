{ config, pkgs, ... }:

# ─────────────────────────────────────────────────────────────────────────────
# Sequestered rofi (application launcher) module.
#
# Not imported from lib/users/brojo/programs/default.nix. The active session is
# Plasma 6, which provides KRunner; rofi is Hyprland-era tooling kept on disk
# (with theme.rasi) for a future Hyprland revival.
#
# To re-enable: add `./rofi` back to the imports in
# lib/users/brojo/programs/default.nix.
# ─────────────────────────────────────────────────────────────────────────────

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
