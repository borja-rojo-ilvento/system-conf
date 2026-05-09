{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hyprpolkitagent.nix
    ./power-management.nix
    ./xbox-controller.nix
    # ./hyprland is intentionally not imported — see lib/system/hyprland/default.nix
    # for the sequestered-but-preserved Hyprland system module.
  ];

  # Nix configuration
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      max-jobs = "auto";
      cores = 0;
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  hardware = {
    steam-hardware.enable = true;
  };

  # Boot configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Basic networking
  networking.networkmanager.enable = true;

  # Locale and timezone
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Audio system
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Shell configuration
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Printing
  services.printing.enable = true;

  # Nixpkgs configuration
  nixpkgs.config = {
    allowUnfree = true;
  };

  # System version
  system.stateVersion = "24.05";

  services = {
    xserver.enable = true; # Required by SDDM even with Wayland session.
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
    desktopManager.plasma6.enable = true;
  };

  # Security services for desktop
  security.pam.services = {
    sddm.enableKwallet = true;
    sddm.gnupg.enable = true;
    login.enableKwallet = true;
    passwd.enableKwallet = true;
  };

  # XDG portal — OS-level desktop integration; lives in the systems layer because
  # it is wanted on every host regardless of which compositor a host composes in.
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.kdePackages.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-hyprland
    ];
    config.common.default = "hyprland";
  };

  # D-Bus session management (enabled by default with desktop environment)
  services.dbus.enable = true;

  # Polkit for privilege escalation
  security.polkit.enable = true;

  # Battery monitoring and notifications
  services.upower.enable = true;

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
}
