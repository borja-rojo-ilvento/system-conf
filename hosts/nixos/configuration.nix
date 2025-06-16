# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./steam.nix
      ./nvidia.nix
      ./obs.nix
    ];
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      max-jobs = "auto";
      cores = 0;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };


  hardware = {
    enableAllFirmware = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

# Sound configuration
  security.rtkit.enable = true;
  security.pam.services = {
    sddm.enableKwallet = true;
    sddm.gnupg.enable = true;

    login.enableKwallet = true;
    passwd.enableKwallet = true;
  };


# Rest of your configuration remains the same
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
    };
  };

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

  services.blueman.enable = true;
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    # Add X11-specific optimizations
    deviceSection = ''
    Option "TearFree" "true"
    Option "TripleBuffer" "true"
    '';
  };
  services.displayManager = {
    sddm = {
      enable = true;
      # Remove all Wayland settings
    };
    defaultSession = "plasmax11";  # Use X11 session
  };
  services.desktopManager.plasma6 = {
    enable = true;
  };
  services.printing.enable = true;
  services.udev.packages = [ pkgs.ledger-udev-rules ];
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  users.users.brojo = {
    isNormalUser = true;
    description = "brojo";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ 
      pkgs.kdePackages.xdg-desktop-portal-kde 
      pkgs.xdg-desktop-portal-gtk  # Better X11 support
    ];
    config.common.default = "kde";
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;


  environment.systemPackages = with pkgs; [
  ];
  environment.variables = {
    # Force applications to use X11
    GDK_BACKEND = "x11";
    QT_QPA_PLATFORM = "xcb";
    NIXOS_OZONE_WL = "0";  # Force Electron apps to X11
  };


  system.stateVersion = "24.05";
}
