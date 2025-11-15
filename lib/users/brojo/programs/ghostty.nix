{ config, pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    settings = {
      # Enable single-instance mode to speed up subsequent window launches
      # When enabled, only one ghostty process runs. Launching additional instances
      # reuses the existing process to create new windows, avoiding GTK startup overhead.
      gtk-single-instance = true;

      # Appearance - using Gruvbox theme for consistency with system
      theme = "Gruvbox Dark";
      font-family = "JetBrains Mono";
      font-size = 11;

      # Performance
      shell-integration = "zsh";
    };
  };

  # Enable the ghostty systemd user service to auto-start at login
  # This pre-initializes ghostty so subsequent window launches are much faster
  systemd.user.services.ghostty = {
    Unit = {
      Description = "Ghostty background service for faster terminal launches";
      After = "graphical-session-pre.target";
      PartOf = "graphical-session.target";
    };

    Service = {
      Type = "dbus";
      BusName = "app.ghostty";
      ExecStart = "${pkgs.ghostty}/bin/ghostty --class=com.mitchellh.ghostty-bg";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
