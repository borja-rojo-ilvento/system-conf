{ disko, ... }:

{
  imports = [
    disko.nixosModules.disko
    ./disk-config.nix
    ./hardware-configuration.nix
  ];

  hardware.enableAllFirmware = true;

  # Installed fresh on 26.11. Set at normal priority rather than mkDefault:
  # lib/system/core.nix already declares a mkDefault "24.05", and two
  # mkDefaults at equal priority conflict rather than one winning.
  system.stateVersion = "26.11";

  # ── Anex: prior approaches ──────────────────────────────────────────────────
  #
  # Directory named after the host rather than the physical box, breaking the
  # `dell-mini-00N` convention in lib/hardware/README.md. The machine's identity
  # is not known yet — horn is defined before anyone has looked at the hardware.
  # Rename this directory once the box is identified; nothing outside
  # flake.nix's `horn` entry refers to it by path.
}
