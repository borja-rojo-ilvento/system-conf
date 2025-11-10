{ config, pkgs, ... }:
{
  imports = [
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    kitty
    ghostty
    networkmanagerapplet
    waybar
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    # Set in the NixOS module needs to be disabled here. Might want to have an elegant solution to this instead of needing to set this null here. PR update?
    package = null;
    portalPackage = null;
  };
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    bind = [
      "$mod, F, exec, firefox"
      "$mod, T, exec, kitty"
      ", Print, exec, grimblast copy area"
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
