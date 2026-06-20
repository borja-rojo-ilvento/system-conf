{ pkgs, ... }:

# ─────────────────────────────────────────────────────────────────────────────
# Sequestered Hyprland polkit-agent module.
#
# This file is intentionally NOT imported from lib/system/base.nix or any active
# composition path. The active session is Plasma 6 / Wayland, which provides
# polkit-kde-agent natively, so this custom unit is redundant. Preserved on disk
# for a future Hyprland revival.
#
# To re-enable: add `./hyprpolkitagent.nix` back to the imports in
# lib/system/base.nix (alongside re-activating lib/system/hyprland/).
# ─────────────────────────────────────────────────────────────────────────────

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
