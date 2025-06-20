{ config, lib, pkgs, ... }:

{
  # Graphics configuration
  hardware.graphics = {
    enable32Bit = true;
  };

  # X11 server configuration
  services.xserver = {
    enable = true;
    # Add X11-specific optimizations
    deviceSection = ''
    Option "TearFree" "true"
    Option "TripleBuffer" "true"
    '';
  };

  # Display manager and desktop environment
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

  # XDG portal configuration for desktop integration
  xdg.portal = {
    enable = true;
    extraPortals = [ 
      pkgs.kdePackages.xdg-desktop-portal-kde 
      pkgs.xdg-desktop-portal-gtk  # Better X11 support
    ];
    config.common.default = "kde";
  };

  # Force applications to use X11
  environment.variables = {
    GDK_BACKEND = "x11";
    QT_QPA_PLATFORM = "xcb";
    NIXOS_OZONE_WL = "0";  # Force Electron apps to X11
  };

  # Security services for desktop
  security.pam.services = {
    sddm.enableKwallet = true;
    sddm.gnupg.enable = true;
    login.enableKwallet = true;
    passwd.enableKwallet = true;
  };
}