{
  config,
  lib,
  pkgs,
  nixos-hardware,
  ...
}:

{
  imports = [
    # Machine-specific hardware configuration
    ./hardware-configuration.nix
    nixos-hardware.nixosModules.lenovo-thinkpad-p14s-intel-gen2
  ];

  # Enable NVIDIA drivers with PRIME offload
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    enableAllFirmware = true;

    # NVIDIA Quadro T500 configuration
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;  # Enable PM for better battery with offload
      open = false;  # Quadro T500 (Turing) - use proprietary for stability
      nvidiaSettings = true;  # Include nvidia-settings utility

      # PRIME offload configuration
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;  # Provides nvidia-offload command
        };
        # PCI Bus IDs from hardware detection
        # card0 = NVIDIA at 0000:01:00.0 -> PCI:1:0:0
        # card1 = Intel at 0000:00:02.0 -> PCI:0:2:0
        nvidiaBusId = "PCI:1:0:0";
        intelBusId = "PCI:0:2:0";
      };
    };

    graphics = {
      enable = true;
      enable32Bit = true;  # Essential for Steam/Wine
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  services.logind.settings.Login = {
    HandleLidSwtich = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "lock";
    HandlePowerKey = "suspend";
  };
}
