{ config, pkgs, ... }:

{

  hardware.graphics.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    # Power management can sleep and halt processes and
    # this setting is here to make that not happen, both
    # by disabling the management and in the case where
    # that kind of thing is force to be done, saving all
    # info for recovery
    powerManagement = {
      enable = false;
      finegrained = false;
    };
    # Not sure if this should actually be false. Setting to false
    # for now as open source drivers may not be mature yet.
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
    prime = {
      sync.enable = true;
      # These values are determined by running `sudo lshw -c display`
      # and they are different for every computer!!!
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };


  environment.systemPackages = with pkgs; [

  ];

}
