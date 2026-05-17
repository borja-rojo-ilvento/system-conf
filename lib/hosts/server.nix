{
  hostname ? "server",
  localIP ? null,
  ethInterface ? null,
  gateway ? "192.168.0.1",
}:
{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../system/core.nix
  ];

  # Host identification
  networking.hostName = hostname;

  # Networking — static if both localIP and ethInterface are provided,
  # otherwise fall back to DHCP. Verify ethInterface with `ip link` before
  # setting it; a wrong name + useDHCP=false will cut off SSH access.
  networking.useDHCP = lib.mkDefault (localIP == null || ethInterface == null);
  networking.interfaces = lib.mkIf (localIP != null && ethInterface != null) {
    ${ethInterface} = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = localIP;
          prefixLength = 24;
        }
      ];
    };
  };
  networking.defaultGateway = lib.mkIf (localIP != null && ethInterface != null) gateway;
  networking.nameservers = lib.mkIf (localIP != null && ethInterface != null) [
    "1.1.1.1"
    "8.8.8.8"
  ];

  # SSH — the only ingress.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

  # brojo as the operator user.
  users.users.brojo = {
    isNormalUser = true;
    description = "brojo";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO//ZN3LvwD7awHobeXg4m89kCP/KJuLvP46OAyxiM8x borja.rojo@gmail.com"
    ];
  };

  # wheel users may sudo without a password — required for `nixos-rebuild
  # --target-host` from a remote operator.
  security.sudo.wheelNeedsPassword = false;

  # ── Anex: prior approaches and why they were dropped ────────────────────────
  #
  # Tried: `imports = [ ../system/base.nix ]` (mirroring lib/hosts/desktop.nix).
  # Rejected because lib/system/base.nix composes a full Plasma 6 desktop
  # (SDDM, plasma6, xserver, KWallet PAM, xdg.portal with KDE + Hyprland
  # portals) plus a desktop-shaped power-management.nix that suspends on idle
  # and assumes a lid switch. Importing it would force ~several GB of Qt/X11
  # closure onto a headless box. The fix was to carve the shared settings into
  # lib/system/core.nix (nix daemon, boot, locale, shell, allowUnfree,
  # stateVersion) which this file now imports instead.
}
