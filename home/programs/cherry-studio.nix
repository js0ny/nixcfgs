{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.packages = [
    pkgs.cherry-studio
  ];
  mergetools.cherry-studio-config = {
    target = "${config.home.homeDirectory}/.config/CherryStudio/config.json";
    format = "json";
    settings = {
      enableDeveloperMode = true;
      enableDataCollection = false;
      autoUpdate = false;
      language = "zh-CN";
      theme = "system";
      tray = true;
      enableQuickAssistant = true;
      clickTrayToShowQuickAssistant = true;
      launchToTray = false;
    };
  };
  nixdots.persist.home = {
    directories = [
      ".config/CherryStudio"
    ];
  };
}
