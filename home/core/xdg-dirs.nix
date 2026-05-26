{
  lib,
  pkgs,
  config,
  ...
}:
let
  xdg-data = config.xdg.dataHome;
  locales = config.nixdots.core.locales;
in
{
  xdg.configFile."user-dirs.locale" = {
    enable = if pkgs.stdenv.isDarwin then false else true;
    text = ''
      ${locales.default}
    '';
  };
  xdg.userDirs = {
    enable = true;
    createDirectories = false;
    setSessionVariables = lib.mkDefault true;
    desktop = lib.mkDefault "$HOME/Desktop";
    documents = lib.mkDefault "$HOME/Documents";
    download = lib.mkDefault "$HOME/Downloads";
    music = lib.mkDefault "$HOME/Music";
    pictures = lib.mkDefault "$HOME/Pictures";
    publicShare = lib.mkDefault "/var/empty";
    templates = lib.mkDefault "${xdg-data}/Templates";
    videos = lib.mkDefault "$HOME/Videos";
  };
}
