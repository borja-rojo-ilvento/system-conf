{
  config,
  lib,
  pkgs,
  ...
}:

# ─────────────────────────────────────────────────────────────────────────────
# Sequestered Hyprland system module.
#
# This file is intentionally NOT imported from lib/system/base.nix or any
# active composition path. It is preserved on disk so the configuration can be
# revived later, but currently every host runs Plasma 6 / Wayland.
#
# To re-enable:
#   1. Add `./hyprland` to imports in lib/system/base.nix.
#   2. Add `./hyprland` to imports in lib/users/brojo/programs/default.nix
#      (the home-manager side).
#   3. Pick which DM session is default in lib/system/base.nix.
# ─────────────────────────────────────────────────────────────────────────────

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # ── Anex: prior approaches and why they were dropped ────────────────────────
  #
  # Tried: hyprland in environment.systemPackages.
  # Removed because programs.hyprland.enable already adds the package to the
  # system; listing it again was redundant and risked version drift if a
  # future toggle pinned one but not the other.
  #
  # Tried: KDE kwallet packages and security.pam.services.login.enableKwallet
  # declared from this Hyprland module.
  # Removed because kwallet is shared across hosts/sessions and is not
  # Hyprland-specific. It now lives once, canonically, in lib/system/base.nix.
}
