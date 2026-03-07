{ config, lib, pkgs, ... }:

{
  # Xbox controller hardware support via xpadneo (Bluetooth)
  hardware.xpadneo.enable = true;

  # Kernel modules for Xbox controller support
  boot.extraModulePackages = with config.boot.kernelPackages; [ xpadneo ];
  boot.kernelModules = [ "uinput" "hid-microsoft" ];

  # xpadneo module parameters for better compatibility
  boot.extraModprobeConfig = ''
    # Xbox controller (xpadneo) configuration
    # disable_deadzones=0: Use default deadzones
    # trigger_rumble_mode=2: Enable trigger rumble if supported
    options hid_xpadneo disable_deadzones=0 trigger_rumble_mode=2
  '';

  # udev rules for Xbox controllers
  services.udev.extraRules = ''
    # Xbox One S/X controllers via Bluetooth (PID 0x02FD, 0x0B20)
    KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="02fd", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b20", MODE="0666", TAG+="uaccess"

    # Generic Xbox controller joystick access
    SUBSYSTEM=="input", ATTRS{name}=="Xbox*", MODE="0666", TAG+="uaccess"
  '';
}
