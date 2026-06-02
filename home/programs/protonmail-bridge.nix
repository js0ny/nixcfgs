{ config, ... }:
{
  services.protonmail-bridge.enable = true;

  nixdots.persist.home.directories = [
    ".config/protonmail"
  ];
  nixdots.persist.nosnap.home.directories = [
    ".local/share/protonmail"
  ];
  systemd.user.tmpfiles.rules = [
    "d ${config.xdg.configHome}/protonmail 0700 ${config.home.username} users -"
    "d ${config.xdg.dataHome}/protonmail/bridge-v3/logs - - - 3d"
    "D ${config.xdg.dataHome}/protonmail/bridge-v3/updates - - - -"
  ];
}
