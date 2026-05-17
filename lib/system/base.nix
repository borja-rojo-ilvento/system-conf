{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./core.nix
    ./hyprpolkitagent.nix
    ./power-management.nix
    ./xbox-controller.nix
    # ./hyprland is intentionally not imported — see lib/system/hyprland/default.nix
    # for the sequestered-but-preserved Hyprland system module.
  ];

  # Hyprland binary cache — desktop hosts only; server builds don't use it.
  nix.settings = {
    substituters         = [ "https://hyprland.cachix.org" ];
    trusted-substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys  = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  hardware.steam-hardware.enable = true;

  # Networking
  networking.networkmanager.enable = true;

  # Audio system
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Printing
  services.printing.enable = true;

  # Display manager and desktop environment
  services = {
    xserver.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    desktopManager.plasma6.enable = true;
    dbus.enable = true;
    upower.enable = true;
  };

  # KWallet PAM integration
  security.pam.services = {
    sddm.enableKwallet  = true;
    sddm.gnupg.enable   = true;
    login.enableKwallet = true;
    passwd.enableKwallet = true;
  };

  # Polkit for privilege escalation
  security.polkit.enable = true;

  # XDG portal — desktop integration for file pickers, screen share, etc.
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.kdePackages.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-hyprland
    ];
    config.common.default = "hyprland";
  };

  # ── Anex: prior approaches and why they were dropped ────────────────────────
  #
  # Tried: nix.settings.auto-optimise-store = true.
  # Removed because it hashes every newly-added store path during the rebuild,
  # noticeably slowing every nixos-rebuild on the laptop. Replaced with the
  # nix.optimise weekly timer above, which runs `nix-store --optimise` out of
  # band.
  #
  # Tried: nixpkgs.config.allowBroken = true.
  # Removed because it suppresses real evaluation errors. If a package needs it
  # in the future, scope it narrowly with allowBrokenPredicate or override the
  # offending package, rather than turning it on globally.
  #
  # Tried: hardware.bluetooth here.
  # Bluetooth is a property of the physical machine, not the OS shape, so it
  # was moved into each hardware/machines/<host>/default.nix that has a BT
  # radio (currently bung-box and brojo-thinkpad-p14s-gen2).
  #
  # Tried: importing ./hyprland from base.nix.
  # The active session is Plasma 6/Wayland on every current host. The Hyprland
  # module is preserved on disk but no longer imported from the active path —
  # see lib/system/hyprland/default.nix for the explanation.
  #
  # Tried: nix settings, boot loader, locale, zsh, allowUnfree, stateVersion
  # directly in this file. Extracted to lib/system/core.nix so server hosts
  # can import the same settings without pulling in the desktop closure.
}
