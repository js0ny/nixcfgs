{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
  home.packages = with pkgs; [ lollypop ];
  dconf.settings = {
    "org/gnome/Lollypop" = {
      music-uris = [
        "file://${config.xdg.userDirs.music}"
      ];
      notification-flag = 2;
    };
  };
}
