{ pkgs, ... }:

# Hyprland-coupled idle/lock pieces. Imported only by the sibling default.nix,
# which is itself sequestered (not on the active import path). See
# ./default.nix for the why.

{
  # Screen locker configuration with swaylock
  programs.swaylock = {
    enable = true;
    settings = {
      # Gruvbox colors for consistency
      color = "282828";
      bs-hl-color = "b8bb26";
      key-hl-color = "fe8019";
      line-color = "504945";
      line-uses-ring = true;
      ring-color = "83a598";
      inside-color = "282828";
      inside-clear-color = "fabd2f";
      inside-ver-color = "83a598";
      inside-wrong-color = "fb4934";
      separator-color = "504945";
      text-color = "ebdbb2";
      text-clear-color = "282828";
      text-ver-color = "282828";
      text-wrong-color = "282828";
      font = "JetBrains Mono";
      font-size = 24;
      indicator-idle-visible = true;
      indicator-radius = 100;
      indicator-thickness = 10;
      show-failed-attempts = true;
    };
  };

  # Hyprland idle management (for screen blanking and locking)
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof swaylock || ${pkgs.swaylock}/bin/swaylock";
        unlock_cmd = "pkill swaylock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      };

      # NOTE: When this module is re-activated, also set
      #   services.logind.settings.Login.IdleAction = "ignore";
      # in the systems layer so logind's 600s suspend does not pre-empt these
      # listeners (the previous setup had logind suspending at 10 min, so the
      # 15 and 30 min hypridle listeners below were dead code).
      listener = [
        {
          # Lock screen after 10 minutes of inactivity
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        {
          # Screen blanking after 15 minutes
          timeout = 900;
          on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
          on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        }
        {
          # Suspend after 30 minutes
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  home.packages = with pkgs; [
    swaylock
    hypridle
  ];

  # Hyprland power keybindings dropped into a sourced fragment.
  home.file.".config/hyprland/power-keybinds.conf".text = ''
    # Power management keybindings

    # Lock screen
    "$mod SHIFT, L, exec, swaylock"

    # Sleep/Suspend
    "$mod SHIFT, S, exec, systemctl suspend"

    # Brightness control
    ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
    ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"

    # Show power menu (commented out - requires additional menu setup)
    # "$mod, P, exec, rofi -show power-menu"
  '';
}
