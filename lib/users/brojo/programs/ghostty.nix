{ config, pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    installBatSyntax = true;
    installVimSyntax = true;
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
      # Optimize padding rendering on Linux/GTK
      window-padding-color = "background";

      # Keybindings
      keybind = "shift+enter=text:\\n";

      # Keep the daemon always running for instant window launches
      quit-after-last-window-closed = false;
    };
  };

  # Pre-warm the ghostty single-instance daemon at login so subsequent windows
  # open instantly. Declared as a Home-Manager-managed user service rather than
  # an imperative `systemctl --user enable` activation hook, so it is fully
  # described by the config and torn down cleanly if removed.
  systemd.user.services.ghostty = {
    Unit = {
      Description = "Ghostty terminal (pre-warmed single-instance daemon)";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${config.programs.ghostty.package}/bin/ghostty";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # ── Anex: prior approaches and why they were dropped ────────────────────────
  #
  # Tried: home.activation.enableGhosttyService running
  #   systemctl --user enable --now app-com.mitchellh.ghostty.service
  # on every rebuild. Replaced with the declarative systemd.user.services unit
  # above: the activation hook depended on the xdg-autostart-generated unit name
  # existing, swallowed all errors with `|| true`, and left the service running
  # even after the config was removed (no declarative teardown).
}
