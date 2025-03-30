# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, claudeDesktop, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./steam.nix
      ./nvidia.nix
      ./obs.nix
    ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
  };
  services.displayManager = {
    sddm = {
      enable = true;
      # Settings for multi-monitor/ dock setup
      settings = {
        General = {
          DisplayServer = "wayland";
          GreeterEnvironment = "QT_QPA_PLATFORM=wayland;QT_WAYLAND_SHELL_INTEGRATION=layer-shell";
        };
        Wayland = {
          CompositorCommand = "kwin_wayland --drm --no-global-shortcuts";
        };
        X11 = {
          ServerArguments = "-nolisten tcp -dpi 96";
          EnableHiDPI = true;
        };
      };
    };
    # autoLogin.user = "brojo";
    defaultSession = "plasma";
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

  users.users.brojo = {
    isNormalUser = true;
    description = "brojo";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    users.brojo = { pkgs, ... }: {
	    home.packages = with pkgs; [ ];
	    programs = {
	      git = {
		  enable = true;
		  userName  = "Borja Rojo Ilvento";
		  userEmail = "borja.rojo@gmail.com";
	      };
	    };
	    # xdg.configFile."kwalletrc".text = ''
	    #   [Wallet]
	    #   Enabled=true
	    #   First Use=false
	    #   Use One Wallet=true
	    #   Default Wallet=kdewallet
	    #   Local Wallet=kdewallet
	    #
	    #   [Auto Allow]
	    #   Enabled=true
	    #   Idle Timeout=0
	    #   Allowed Applications=*
	    #
	    #   [Auto Close]
	    #   Enabled=false
	    #
	    #   [Auto Deny]
	    #   Enabled=false
	    #
	    #   [General]
	    #   CloseWhenNoWindow=false
	    #   ShowSystemTray=false
	    #
	    #   [Passwords]
	    #   Store New Passwords=true
	    #
	    #   [Auto Unlock]
	    #   Enabled=true
	    #
	    #   [Migration]
	    #   alreadyMigrated=true
	    # '';
	    home.stateVersion = "24.11";
	  };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;


  environment.systemPackages = with pkgs; [
    firefox
    neovim
    wget
    git
    code-cursor
    windsurf
    discord
    xwayland
    zoxide
    flameshot
    fzf
    ledger-live-desktop
    ledger-udev-rules
    kdePackages.kscreen
    home-manager
    nmap
    arp-scan
    google-chrome
    stremio
    obsidian
    minecraft
    jdk
    devbox
    claudeDesktop.packages.${pkgs.system}.claude-desktop-with-fhs
  ];


  system.stateVersion = "24.05";
}
