{ pkgs, ... }:
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        geometry = "300x5-30+20";
        progress_bar = true;
        indicate_hidden = "yes";
        transparency = 10;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        frame_width = 2;
        frame_color = "#aaaaaa";
        separator_color = "frame";
        sort = "yes";
        idle_threshold = 120;
        font = "Monospace 10";
        markup = "full";
        format = "<b>%s</b>\n%b";
        alignment = "left";
        show_age_threshold = 60;
        ellipsize = "middle";
        stack_duplicates = true;
        sticky_history = "yes";
        history_length = 20;
        browser = "firefox";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        startup_notification = false;
      };
      urgency_low = {
        background = "#222222";
        foreground = "#888888";
        frame_color = "#444444";
        timeout = 4;
      };
      urgency_normal = {
        background = "#285577";
        foreground = "#ffffff";
        frame_color = "#407294";
        timeout = 6;
      };
      urgency_critical = {
        background = "#900000";
        foreground = "#ffffff";
        frame_color = "#ff0000";
        timeout = 0;
      };
    };
  };
}
