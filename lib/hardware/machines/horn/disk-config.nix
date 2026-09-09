# Disko partition layout for host `horn`.
#
# Present so that `nixos-anywhere --flake .#horn` partitions and formats the
# target without any manual parted/mkfs step: disko creates the partitions and
# derives the `fileSystems` entries from this declaration, so no UUID has to be
# looked up on the installed machine afterwards.
#
# nixos-anywhere WILL DESTROY EVERYTHING ON `device`.
{ ... }:

{
  disko.devices.disk.main = {
    # UNVERIFIED. Every other machine in this repo had its device path checked
    # against the running target first; horn has not been booted or inspected.
    # Before running nixos-anywhere, SSH into the target and run
    #   lsblk -d -o NAME,SIZE,TYPE,MODEL
    # then correct this path. Note that the installer USB itself shows up as a
    # disk (it was /dev/sda on dell-mini-002) — do not aim disko at it.
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
