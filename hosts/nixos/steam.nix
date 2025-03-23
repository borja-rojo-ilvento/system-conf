{ config, pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    steam-run
    (makeDesktopItem {
      name = "steam-fhs";
      exec = "${steam-run}/bin/steam-run ${steam}/bin/steam";
      icon = "steam";
      desktopName = "Steam (FHS)";
      categories = ["Game"];
    })
  ];

}
