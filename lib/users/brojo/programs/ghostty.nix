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

  # Enable ghostty systemd service for automatic startup on login
  # This ensures the daemon is running and ready for instant window launches
  # Uses Home Manager activation script to ensure persistence across rebuilds
  home.activation.enableGhosttyService = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.systemd}/bin/systemctl --user enable --now app-com.mitchellh.ghostty.service || true
  '';

}
