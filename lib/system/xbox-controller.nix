{ config, lib, pkgs, ... }:

{
  # Xbox One S/X controller support via Bluetooth (xpadneo driver)
  #
  # Note: Requires controller firmware to be up-to-date. Update via Windows
  # Xbox Accessories app if you encounter "probe failed with error -22" errors.

  hardware.xpadneo.enable = true;
}

