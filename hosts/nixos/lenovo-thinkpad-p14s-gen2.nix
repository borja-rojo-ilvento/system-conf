{ nixos-hardware, lib, ... }:
{
  imports = [
    nixos-hardware.nixosModules.lenovo-thinkpad-p14s-intel-gen3
  ];

  hardware.nvidia = {
    prime = {
      intelBusId = lib.mkForce "PCI:0:2:0";
      nvidiaBusId = lib.mkForce "PCI:1:0:0";
    };
    modesetting.enable = lib.mkForce false;  # Disable for X11
    # Force performance mode for X11
    forceFullCompositionPipeline = lib.mkForce true;
  };

}
