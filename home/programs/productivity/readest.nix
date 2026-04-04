{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = [
    pkgs.readest
  ];
  mergetools.readest-settings = {
    target = "${config.home.homeDirectory}/.config/com.bilingify.readest/settings.json";
    format = "json";
    settings = {
      globalViewSettings = {
        serifFont = "LXGW WenKai GB Screen";
        defaultCJKFont = "LXGW WenKai GB Screen";
        sansSerifFont = config.stylix.fonts.sansSerif.name;
        monospaceFont = "${config.stylix.fonts.monospace.name} Regular";
        uiLanguage = "zh-CN";
      };
      telemetryEnabled = false;
    };
  };
  nixdots.persist.home = {
    directories = [
      ".config/com.bilingify.readest"
      ".local/share/com.bilingify.readest"
    ];
  };
}
