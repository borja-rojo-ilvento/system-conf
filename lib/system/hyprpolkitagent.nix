{ pkgs, ... }:
{
  # Hyprland Polkit agent for privilege escalation prompts
  systemd.user.services.hyprpolkitagent = {
    description = "Hyprland Polkit Agent";
    after = [ "graphical-session-pre.target" ];
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };
}
