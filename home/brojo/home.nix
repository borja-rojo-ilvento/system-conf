{ config, pkgs, ... }:

{
  home.packages = with pkgs; [];

  programs.git = {
    enable = true;
    userName = "Borja Rojo Ilvento";
    userEmail = "borja.rojo@gmail.com";
  };

  # Uncomment if you need to set up kwallet configuration
  # xdg.configFile."kwalletrc".text = ''
  #   [Wallet]
  #   Enabled=true
  #   First Use=false
  #   Use One Wallet=true
  #   Default Wallet=kdewallet
  #   Local Wallet=kdewallet
  #
  #   [Auto Allow]
  #   Enabled=true
  #   Idle Timeout=0
  #   Allowed Applications=*
  #
  #   [Auto Close]
  #   Enabled=false
  #
  #   [Auto Deny]
  #   Enabled=false
  #
  #   [General]
  #   CloseWhenNoWindow=false
  #   ShowSystemTray=false
  #
  #   [Passwords]
  #   Store New Passwords=true
  #
  #   [Auto Unlock]
  #   Enabled=true
  #
  #   [Migration]
  #   alreadyMigrated=true
  # '';

  home.stateVersion = "24.11";
}
