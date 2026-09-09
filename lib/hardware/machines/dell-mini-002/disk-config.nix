# Disko partition layout for the second Dell Mini (host `snow`).
#
# This replaces the manual parted/mkfs steps and, more importantly, replaces
# the UUID guesswork: disko both creates the partitions and derives the
# `fileSystems` entries from this declaration, so nothing has to be looked up
# on the installed machine afterwards.
#
# nixos-anywhere WILL DESTROY EVERYTHING ON `device`. Confirm the path with
# `lsblk -d -o NAME,SIZE,TYPE,MODEL` on the target before running the install.
{ ... }:

{
  disko.devices.disk.main = {
    # Verified against the target on 2026-09-09 from the NixOS installer:
    # nvme0n1 is a 232.9G Samsung SSD 970 EVO. /dev/sda on that machine is
    # the USB installer stick, not a fixed disk.
    device = "/dev/nvme0n1";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };
}
