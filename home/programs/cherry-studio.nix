{
  pkgs,
  lib,
  config,
  ...
}:
let
  dotDir = ".local/share/CherryStudio";
in
{
  home.packages = [
    (pkgs.nixpaks.cherry-studio.override {
      dotDir = dotDir;
    })
  ];
  mergetools.cherry-studio-config = {
    target = "${config.home.homeDirectory}/.config/CherryStudio/config.json";
    format = "json";
    settings = {
      enableDeveloperMode = true;
      enableDataCollection = false;
      autoUpdate = false;
      language = config.nixdots.core.locales.guiLocale;
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
  systemd.user.tmpfiles.rules = (
    lib.optionals config.nixdefs.mcp.enable [
      "L+ ${config.home.homeDirectory}/${dotDir}/bin/uv - - - - ${lib.getExe pkgs.uv}"
      "L+ ${config.home.homeDirectory}/${dotDir}/bin/bun - - - - ${lib.getExe pkgs.bun}"
    ]
  );
}
