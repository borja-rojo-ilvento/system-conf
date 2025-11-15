{ pkgs, ... }:
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        # Hyprland-specific positioning (top-right corner)
        monitor = 0;
        follow = "none";
        # Width x Height - Xoffset+Yoffset (top-right for Hyprland)
        geometry = "350x100-10+40";
        progress_bar = true;
        progress_bar_height = 8;
        progress_bar_frame_width = 1;
        indicate_hidden = "yes";
        transparency = 5;
        separator_height = 2;
        padding = 10;
        horizontal_padding = 12;
        frame_width = 2;
        frame_color = "#aaaaaa";
        separator_color = "frame";
        sort = "yes";
        idle_threshold = 120;
        font = "Monospace 11";
        markup = "full";
        format = "<b>%s</b>\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        stack_duplicates = true;
        sticky_history = "yes";
        history_length = 20;
        browser = "firefox";
        always_run_script = false;
        title = "Dunst";
        class = "Dunst";
        startup_notification = false;
      };

      urgency_low = {
        background = "#222222";
        foreground = "#888888";
        frame_color = "#444444";
        timeout = 4;
        sound = "complete";
      };

      urgency_normal = {
        background = "#285577";
        foreground = "#ffffff";
        frame_color = "#407294";
        timeout = 6;
        sound = "message";
      };

      urgency_critical = {
        background = "#900000";
        foreground = "#ffffff";
        frame_color = "#ff0000";
        timeout = 0;
        sound = "alarm-clock-elapsed";
      };
    };
  };
}
