{ config, ... }:
let
  xdg-data = "${config.xdg.dataHome}";
  user = config.home.username;
in
{
  nixdots.persist.home = {
    directories = [
      {
        directory = ".local/share/gnupg";
        mode = "0700";
      }
    ];
  };
  home.sessionVariables = {
    GNUPGHOME = "${xdg-data}/gnupg";
  };
  systemd.user.tmpfiles.rules = [
    "d ${xdg-data}/gnupg 0700 ${user} users -"
  ];
}
