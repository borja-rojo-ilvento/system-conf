{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    networkmanagerapplet
    nerd-fonts.jetbrains-mono
  ];
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        margin-left = 4;
        margin-right = 4;
        margin-top = 4;
        margin-bottom = 0;
        spacing = 1;
        reload_style_on_change = true;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];

        modules-center = [ ];

        modules-right = [
          "network"
          "backlight"
          "wireplumber"
          "battery"
          "clock"
        ];

        "hyprland/workspaces" = {
          format = "{icon}";
          all-outputs = false;
          on-click = "activate";
          persistent-workspaces = {
            "*" = [
              1
              2
              3
              4
              5
              6
              7
              8
              9
            ];
          };
          format-icons = {
            "1" = "●";
            "2" = "●";
            "3" = "●";
            "4" = "●";
            "5" = "●";
            "6" = "●";
            "7" = "●";
            "8" = "●";
            "9" = "●";
            "active" = "●";
            "default" = "●";
          };
        };

        "hyprland/window" = {
          format = "{title}";
        };

        network = {
          interval = 1;
          format-wifi = "{essid}";
          format-ethernet = "󰈀 Ethernet";
          tooltip-format-ethernet = "󰈀 {ipaddr}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)";
          tooltip-format = "󰤯 {ifname} via {gwaddr}";
          format-linked = "󰀦 {ifname} (No IP)";
          format-disconnected = "󰀦 Disconnected";
          format-alt = "{ifname}: {gwaddr}/{cidr}";
        };

        backlight = {
          format = "{icon} {percent}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };

        wireplumber = {
          format = "{icon} {volume}%";
          format-muted = "󰖁 {volume}%";
          format-icons = [
            ""
            ""
            ""
          ];
          on-click = "pavucontrol";
        };

        battery = {
          format = "{icon} {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          interval = 2;
        };

        clock = {
          interval = 60;
          format = "{:%I:%M %p}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%a %b %d}";
        };
      };
    };
    style = ''
      * {
        min-height: 0;
        font-family: "JetBrainsMono Nerd Font", Roboto, Helvetica, Arial, sans-serif;
        font-size: 1rem;
        margin: 0;
        padding: 0;
      }

      window#waybar {
        color: #ebdbb2;
        background-color: transparent;
        background: none;
        border: none;
      }

      #window,
      #workspaces {
        color: #ebdbb2;
        background-color: #282828;
        border: 0.1rem solid #504945;
        border-radius: 0.5rem;
        padding: 0.1rem 0.5rem;
        margin: 0.1rem;
      }

      #workspaces button {
        color: #504945;
        background-color: transparent;
        border: 0rem;
        padding: 0.1rem 0.3rem;
        margin: 0.1rem;
        box-shadow: none;
      }

      #workspaces button:hover,
      #workspaces button:focus,
      #workspaces button:active {
        background-color: transparent;
        box-shadow: none;
        color: #504945;
      }

      #workspaces button.active {
        color: #d79921;
      }

      #workspaces button.active:hover,
      #workspaces button.active:focus,
      #workspaces button.active:active {
        background-color: transparent;
        box-shadow: none;
        color: #d79921;
      }

      /* Occupied but not active - requires custom module or script to distinguish */
      /* #workspaces button.occupied:not(.active) {
        color: #d79921;
      } */

      #clock,
      #battery,
      #backlight,
      #network,
      #wireplumber {
        color: #282828;
        background-color: #282828;
        border: 0.1rem solid #504945;
        border-radius: 0.5rem;
        padding: 0.1rem 0.5rem;
        margin: 0.1rem;
      }

      #network {
        background-color: #458588;
        color: #ebdbb2;
      }

      #backlight {
        background-color: #d79921;
        color: #282828;
      }

      #wireplumber {
        background-color: #b8bb26;
        color: #282828;
      }

      #battery {
        background-color: #98971a;
        color: #282828;
      }

      #clock {
        background-color: #458588;
        color: #ebdbb2;
      }

      #window {
        background-color: #689d6a;
        color: #282828;
      }

      #network.disconnected,
      #wireplumber.muted {
        background-color: #cc241d;
        color: #ebdbb2;
      }

      #battery.charging,
      #battery.plugged {
        background-color: #b8bb26;
        color: #282828;
      }
    '';
  };
}
