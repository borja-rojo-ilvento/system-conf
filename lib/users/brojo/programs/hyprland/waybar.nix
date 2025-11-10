{ config, pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [
          "hyprland/window"
        ];
        modules-right = [
          "tray"
          "network"
          "pulseaudio"
          "clock"
        ];

        "hyprland/workspaces" = {
          format = "{name}";
        };

        "hyprland/window" = {
          max-length = 250;
        };

        tray = {
          icon-size = 18;
          spacing = 8;
        };

        network = {
          format = "󰤨 {essid}";
          format-disconnected = "󰤯";
          on-click = "nm-applet --indicator";
          tooltip-format = "Interface: {ifname}";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟 Muted";
          format-icons = {
            headphone = "󰋋";
            hands-free = "󱡒";
            headset = "󰋎";
            phone = "󰏲";
            portable = "󰏲";
            car = "󰄎";
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };
          on-click = "pavucontrol";
        };

        clock = {
          format = "󰃰 {:%I:%M %p}";
          tooltip-format = "{:%A, %B %d, %Y}";
        };
      };
    };
    style = ''
      * {
        font-family: "monospace";
        font-size: 13px;
      }

      window#waybar {
        background-color: #1e1e2e;
        color: #cdd6f4;
        border-bottom: 3px solid #313244;
      }

      #workspaces button {
        padding: 5px 10px;
        margin: 5px 2px;
        border-radius: 5px;
        background-color: #313244;
        color: #cdd6f4;
        transition: all 0.3s ease;
      }

      #workspaces button.active {
        background-color: #a6e3a1;
        color: #1e1e2e;
      }

      #workspaces button:hover {
        background-color: #45475a;
      }

      #window {
        padding: 0 10px;
        margin: 0 5px;
      }

      #tray {
        padding: 5px 10px;
        margin: 5px 2px;
      }

      #network,
      #pulseaudio,
      #clock {
        padding: 5px 10px;
        margin: 5px 2px;
        background-color: #313244;
        border-radius: 5px;
      }

      #network.disconnected {
        color: #f38ba8;
      }

      #pulseaudio.muted {
        color: #f38ba8;
      }
    '';
  };
}
