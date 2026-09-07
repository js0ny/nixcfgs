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
  xdg.binHome = "${config.home.homeDirectory}/.local/bin";
  xdg.localBinInPath = true;
  js0ny.persist.stores.state.directories = [
    (lib.removePrefix "${config.home.homeDirectory}/" config.xdg.binHome)
  ];
  xdg.configFile."user-dirs.locale" = {
    enable = !pkgs.stdenv.hostPlatform.isDarwin;
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
}
