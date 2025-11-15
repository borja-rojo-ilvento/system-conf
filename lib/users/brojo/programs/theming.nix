{ pkgs, ... }:
{
  # GTK theming configuration - Gruvbox with minimalist design
  gtk = {
    enable = true;
    # Using Gruvbox theme for minimalist aesthetic
    theme = {
      name = "Gruvbox-Dark";
      package = pkgs.gruvbox-gtk-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      size = 24;
    };
    font = {
      name = "JetBrains Mono";
      size = 10;
    };
    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
        # Minimalist decoration - no shadows or excessive styling
        gtk-decoration-layout = "menu:minimize,maximize,close";
        gtk-enable-animations = true;
        gtk-primary-button-warps-slider = false;
      };
      extraCss = ''
        /* Minimalist GTK3 styling */
        * {
          border-radius: 0px;
        }

        window {
          background-color: #282828;
        }

        /* Remove shadows from windows and panels */
        .window-frame, .window-frame:backdrop {
          box-shadow: none;
          border: none;
        }

        /* Minimize button styling - rely on icons */
        button {
          border: none;
          box-shadow: none;
          padding: 4px 8px;
        }

        button:hover {
          background-color: #3c3836;
        }

        button:active {
          background-color: #504945;
        }
      '';
    };
    gtk4 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-enable-animations = true;
      };
      extraCss = ''
        /* Minimalist GTK4 styling */
        * {
          border-radius: 0px;
        }

        window {
          background-color: #282828;
        }

        /* Remove shadows */
        .window-frame, .window-frame:backdrop {
          box-shadow: none;
          border: none;
        }

        /* Clean button styling */
        button {
          border: none;
          box-shadow: none;
          padding: 4px 8px;
          border-radius: 0px;
        }

        button:hover {
          background-color: #3c3836;
        }

        button:active {
          background-color: #504945;
        }
      '';
    };
  };

  # Qt theming (for Qt applications)
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "gtk3";
  };

  # Gruvbox color scheme configuration for consistency across applications
  home.file = {
    ".config/colorscheme".text = ''
      # Gruvbox color scheme - minimalist design
      # Dark mode (bg=#282828)

      # Hard contrast dark background
      bg_hard=#1d2021
      bg=#282828
      bg_soft=#32302f

      # Foreground colors
      fg=#ebdbb2
      fg_light=#f9f5d4

      # Grays (for UI elements and text hierarchy)
      gray_dark=#3c3836
      gray=#504945
      gray_light=#665c54
      gray_lighter=#7c6f64

      # Accent colors (used for status, selection, and icon changes)
      red=#fb4934
      green=#b8bb26
      yellow=#fabd2f
      blue=#83a598
      purple=#d3869b
      aqua=#8ec07c
      orange=#fe8019

      # UI palette - minimal use
      # Selection: green accent
      # Active: orange accent
      # Error: red
      # Success: green
      # Warning: yellow
    '';
  };

  # Configure GTK to use minimal decorations
  xdg.configFile = {
    "gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=Gruvbox-Dark
      gtk-icon-theme-name=Papirus-Dark
      gtk-font-name=JetBrains Mono 10
      gtk-cursor-theme-name=Adwaita
      gtk-cursor-theme-size=24
      gtk-application-prefer-dark-theme=true
      gtk-enable-animations=true
      gtk-decoration-layout=menu:minimize,maximize,close
      gtk-button-images=true
      gtk-menu-images=true
      gtk-primary-button-warps-slider=false
    '';
  };

  # Additional theme packages
  home.packages = with pkgs; [
    gruvbox-gtk-theme
    papirus-icon-theme
    papirus-folders
    xdg-desktop-portal-hyprland
  ];
}
