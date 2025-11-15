{ pkgs, ... }:
{
  # Input method framework configuration
  # Using fcitx5 as the primary IME framework (modern, Wayland-friendly)

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons  # Chinese input support (Pinyin)
      fcitx5-mozc            # Japanese input support (Google's Mozc)
    ];
  };

  # Input method configuration files
  xdg.configFile = {
    # Fcitx5 main configuration
    "fcitx5/conf/classicui.conf".text = ''
      [Behavior]
      # Candidate box positioning (for Hyprland/Wayland)
      FollowCursor=True
      PreeditTextInApplication=True
      ShowPreviewTextBeforePreedit=False

      [Appearance]
      # Gruvbox colors for consistency
      BackgroundColor=#282828
      BorderColor=#504945
      TextColor=#ebdbb2
      HighlightCandidateBg=#fe8019
      HighlightCandidateFg=#282828
      HighlightColor=#83a598
      Font=JetBrains Mono 10
    '';

    # Fcitx5 configuration
    "fcitx5/conf/fcitx5.conf".text = ''
      [Hotkey]
      # Toggle input method
      # Default: Ctrl+Space
      TriggerKeys=Control+space

      # Switch between input methods
      EnumerateWithTriggerKeys=True
      EnumerateForwardKeys=
      EnumerateBackwardKeys=

      # Enumerate mode
      EnumerateGroupForwardKeys=Super+Tab
      EnumerateGroupBackwardKeys=Super+Shift+Tab

      [Behavior]
      PreeditEnabledByDefault=True
      ShowPreedit=True
      SharedInputMethodState=No
      DefaultPageSize=5

      [Addons]
      # Enabled addons
    '';

    # English input method
    "fcitx5/conf/keyboard-us.conf".text = ''
      [Keyboard]
      # US English keyboard layout
      Layout=us
      Variant=
      Options=
    '';

    # Chinese input (if needed)
    "fcitx5/conf/pinyin.conf".text = ''
      [Pinyin]
      # Pinyin configuration for Chinese input
      # PinyinMode options: Simplified, Traditional, Simplified_sc
      PinyinMode=Simplified

      # Fuzzy search
      FuzzySearch=False
    '';
  };

  # Home Manager environment setup for input methods
  home.sessionVariables = {
    # Set GTK_IM_MODULE for GTK applications
    GTK_IM_MODULE = "fcitx";
    # Set QT_IM_MODULE for Qt applications
    QT_IM_MODULE = "fcitx";
    # Set XMODIFIERS for X11 applications
    XMODIFIERS = "@im=fcitx";
  };

  # Shell integration for input method switching
  programs.zsh.initContent = ''
    # Input method shortcuts
    alias ime-en='fcitx5-remote -s keyboard-us'
    alias ime-zh='fcitx5-remote -s pinyin'
    alias ime-jp='fcitx5-remote -s mozc'
    alias ime-toggle='fcitx5-remote -t'
    alias ime-status='fcitx5-remote -s'
  '';

  # Hyprland-specific configuration for input method
  # Add to hyprland config via environment variables
  home.file = {
    ".config/hyprland/ime-config.conf".text = ''
      # Input method configuration for Hyprland

      # Use Fcitx5 for input method handling
      # Fcitx5 will automatically handle candidate window positioning
      # in Wayland via zwp_text_input_v3

      # Keybindings for input method control
      # These can be added to main hyprland config if needed
      # $mod, grave, exec, fcitx5-remote -t
    '';
  };
}
