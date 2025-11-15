{ config, pkgs, ... }:
{
  imports = [
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    ghostty
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    # Set in the NixOS module needs to be disabled here. Might want to have an elegant solution to this instead of needing to set this null here. PR update?
    package = null;
    portalPackage = null;
  };
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    input = {
      kb_layout = "us";
      kb_variant = "qwerty";
      kb_options = "caps:ctrl_modifier";
      repeat_rate = 50;
      repeat_delay = 200;

      sensitivity = 0.5;
      follow_mouse = 2;

      touchpad = {
        natural_scroll = false;
        clickfinger_behavior = true;
        disable_while_typing = true;
        tap-to-click = false;
        tap-and-drag = false;
        middle_button_emulation = false;
        scroll_factor = 1.0;
      };
    };
    animations = {
      enabled = true;

      # Bezier curves for quick animations with momentum
      bezier = [
        "easeOutQuint, 0.23, 1, 0.32, 1" # Smooth deceleration
        "almostLinear, 0.5, 0.5, 0.75, 1" # Nearly instant with subtle ease
        "linear, 0, 0, 1, 1" # No easing
      ];

      # Window animations - responsive with momentum
      animation = [
        "windows, 1, 1.8, easeOutQuint"
        "windowsIn, 1, 1.5, easeOutQuint, popin 87%"
        "windowsOut, 1, 0.8, linear, popin 87%"

        # Fade effects - very quick
        "fadeIn, 1, 0.9, almostLinear"
        "fadeOut, 1, 0.7, almostLinear"
        "fade, 1, 1.2, almostLinear"

        # Workspace switching - matches keystroke speed
        "workspaces, 1, 1.0, almostLinear, fade"
        "workspacesIn, 1, 0.9, almostLinear, fade"
        "workspacesOut, 1, 0.9, almostLinear, fade"

        # Layers
        "layers, 1, 1.4, easeOutQuint"
        "layersIn, 1, 1.3, easeOutQuint, fade"
        "layersOut, 1, 0.8, linear, fade"

        # Borders
        "border, 1, 2.0, easeOutQuint"
        "borderangle, 1, 180, linear, loop"
      ];
    };
    general = {
      gaps_in = 2;
      gaps_out = 4;
      border_size = 1; # Minimal border (1px line)

      # Border colors - active window shows border, inactive transparent
      "col.active_border" = "rgba(c28f23ff)";
      "col.inactive_border" = "rgba(444444ff)"; # Fully transparent for inactive windows

      # Use master-stack layout
      layout = "master";

      # Don't resize on border grab
      resize_on_border = false;
      allow_tearing = false;
    };
    decoration = {
      # Light window rounding to soften sharp edges
      rounding = 5;
    };
    master = {
      # Master window takes 60% of screen width
      mfact = 0.60;

      # Master on left, slaves on right (can cycle with $mod CTRL Space)
      orientation = "left";

      # New windows become master focus
      new_status = "master";

      # Stack new masters at the top
      new_on_top = true;

      # Smart resizing based on mouse position
      smart_resizing = true;

      # Don't drop windows at cursor when dragging
      drop_at_cursor = false;

      # Center orientation configuration
      # Master always centered (regardless of slave count)
      slave_count_for_center_master = 0;
    };
    bind = [
      "$mod, F, exec, firefox"
      "$mod, Return, exec, ghostty"
      ", Print, exec, grimblast copy area"

      # Focus navigation in master layout (Vim-like)
      "$mod, j, layoutmsg, cyclenext"
      "$mod, k, layoutmsg, cycleprev"
      "$mod, h, layoutmsg, focusmaster previous"

      # Window movement in master layout
      "$mod SHIFT, j, layoutmsg, swapnext"
      "$mod SHIFT, k, layoutmsg, swapprev"
      "$mod SHIFT, h, layoutmsg, swapwithmaster master"

      # Cycle master layout orientation
      "$mod CTRL, Space, layoutmsg, orientationcycle left center"

      # Audio control via wpctl (volume)
      ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

      # Media control via playerctl
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"
    ]
    ++ (
      # workspaces
      # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
      builtins.concatLists (
        builtins.genList (
          i:
          let
            ws = i + 1;
          in
          [
            "$mod, code:1${toString i}, workspace, ${toString ws}"
            "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]
        ) 9
      )
    );
    exec-once = [
      "nm-applet --indicator"
      "waybar"
    ];
  };
}
