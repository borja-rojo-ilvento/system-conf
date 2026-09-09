# Home Manager environment for the `valheim` service account.
#
# Deliberately thin. This account exists to run and inspect one systemd
# service, not to be worked in — so it gets a usable shell and the handful of
# verbs an operator reaches for, and nothing else. The system-level user
# (home, SSH keys, group) is declared by lib/services/valheim.nix.
{ pkgs, ... }:
let
  # Kept in sync with services.valheim.home / .dataDir defaults.
  dataDir = "/var/lib/valheim/valheim-server";
in
{
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    ripgrep
    tree
  ];

  programs.zsh = {
    enable = true;

    shellAliases = {
      vh-status = "systemctl status valheim-server";
      vh-log = "journalctl -u valheim-server -f";
      vh-start = "systemctl start valheim-server";
      vh-stop = "systemctl stop valheim-server";
      vh-restart = "systemctl restart valheim-server";
      # An update is applied by ExecStartPre, so "update" is just a restart.
      vh-update = "valheim-update";

      vh-backup = "systemctl start valheim-backup-hourly";
      vh-backup-daily = "systemctl start valheim-backup-daily";
      vh-timers = "systemctl list-timers 'valheim-*'";

      vh-worlds = "ls -lh ${dataDir}/save/worlds_local";
      vh-backups = "ls -lhtR ${dataDir}/backups";
      vh-data = "cd ${dataDir}";
    };

    initContent = ''
      cat <<'BANNER'
      valheim server account
        vh-status / vh-log / vh-restart      service control
        vh-update                            pull the latest game build
        vh-backup / vh-backup-daily          take a backup now
        vh-timers                            when the scheduled jobs next run
        vh-worlds / vh-backups / vh-data     state under ${dataDir}
      BANNER
    '';
  };
}
