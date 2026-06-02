{
  lib,
  pkgs,
  config,
  ...
}:
let
  xdg-data = config.xdg.dataHome;
  locales = config.nixdots.core.locales;
  inherit (lib) mkDefault;
in
{
  xdg.configFile."user-dirs.locale" = {
    enable = !pkgs.stdenv.isDarwin;
    text = "${locales.default}";
  };
  xdg.userDirs = {
    enable = true;
    createDirectories = false;
    setSessionVariables = mkDefault true;
    desktop = mkDefault "$HOME/Desktop";
    documents = mkDefault "$HOME/Documents";
    download = mkDefault "$HOME/Downloads";
    music = mkDefault "$HOME/Music";
    pictures = mkDefault "$HOME/Pictures";
    publicShare = mkDefault "/var/empty";
    templates = mkDefault "$HOME/.local/share/Templates";
    videos = mkDefault "$HOME/Videos";
  };
  nixdots.persist.home.directories = [ ];
  nixdots.persist.nosnap.home.directories =
    let
      toPersist = dir: lib.removePrefix "$HOME/" dir;
      xdgDirs = config.xdg.userDirs;
    in
    [
      (toPersist xdgDirs.music)
      (toPersist xdgDirs.pictures)
      (toPersist xdgDirs.videos)
    ];
}
