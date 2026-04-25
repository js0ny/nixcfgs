{
  lib,
  pkgs,
  config,
  ...
}:
let
  xdg-data = config.xdg.dataHome;
in
lib.mkIf pkgs.stdenv.isLinux {
  xdg.configFile."user-dirs.locale".text = ''
    en_GB.UTF-8
  '';
  xdg.userDirs = {
    enable = true;
    createDirectories = false;
    setSessionVariables = true;
    desktop = "$HOME/Desktop";
    documents = "$HOME/Documents";
    download = "$HOME/Downloads";
    music = "$HOME/Music";
    pictures = "$HOME/Pictures";
    publicShare = "/var/empty";
    templates = "${xdg-data}/Templates";
    videos = "$HOME/Videos";
  };
}
