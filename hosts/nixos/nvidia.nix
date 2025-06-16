{ config, pkgs, ... }:

{

  hardware.graphics.enable = true;

  hardware.nvidia = {
    modesetting.enable = false;  # Disable for X11
    powerManagement = {
      enable = false;
      finegrained = false;
    };
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;

    # Force performance mode for X11
    forceFullCompositionPipeline = true;

    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

}
