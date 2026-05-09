{
  hostname ? "default",
}:
{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Base system configuration
    ../system/base.nix
  ];

  # Host identification
  networking.hostName = hostname;

  # Productivity host services
  services.udev.packages = [ pkgs.ledger-udev-rules ];

  # NetworkManager credential storage
  networking.networkmanager.settings = {
    "main" = {
      auth-polkit = "yes";
    };
  };

  # WiFi auto-connect configuration
  # The WiFi profile is not declaratively managed via ensureProfiles to allow
  # the user to enter and securely store the password once without it being
  # overwritten on each boot. The connection persists in NetworkManager's
  # system-connections directory after manual setup.
  #
  # To set up jean.net WiFi:
  # 1. Run: nmcli device wifi connect jean.net password <password>
  # 2. Or use: nmcli connection add type wifi con-name jean.net ssid jean.net
  # 3. The connection will auto-connect on subsequent logins

  # Gaming configuration
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      gamescopeSession.enable = true;

      # Ensure proper controller support
      extest.enable = true; # Enable EXTEST protocol for Steam Input

      # Add NVIDIA libraries to Steam FHS environment
      extraPackages = with pkgs; [
        libva
      ];
    };
    gamemode.enable = true;
    gamescope = {
      enable = true;
      capSysNice = true;
    };
  };

  # Performance optimization for OBS
  systemd.services.obs = {
    serviceConfig = {
      CPUAffinity = "6 7"; # Dedicating threads 6-7 (last physical core)
      Nice = -10; # Higher priority but not maximum
    };
  };

  # Users configuration
  users.users.brojo = {
    isNormalUser = true;
    description = "brojo";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # ── Anex: prior approaches and why they were dropped ────────────────────────
  #
  # Tried: programs.hyprland.enable + withUWSM here, plus xdg.portal.enable
  # toggled from this layer.
  # Both moved out: hyprland enablement now lives entirely inside
  # lib/system/hyprland/default.nix (which is intentionally not imported — see
  # that file), and xdg.portal lives in lib/system/base.nix as part of the
  # systems-layer OS shape. The hosts layer is intended to wire composition
  # rather than introduce compositor-specific knobs.
  #
  # Tried: services.flatpak.enable plus a oneshot systemd.services.flatpak-repo
  # that ran `flatpak remote-add --if-not-exists flathub …` on every boot.
  # Introduced alongside the lutris/bottles/heroic gaming-launcher push but
  # never used to install an app (flatpak list was empty). Once lutris and
  # bottles were dropped, nothing on the system depended on flatpak. Removed
  # because the unit also raced DNS at boot and surfaced as a recurring
  # `systemctl --failed` entry.
}

