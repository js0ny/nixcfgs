{
  pkgs,
  lib,
  config,
  ...
}:
let
  dotDir = ".local/share/CherryStudio";
  electronBase =
    if pkgs.stdenv.isDarwin then
      "${config.home.homeDirectory}/Library/Application Support"
    else
      "${config.xdg.configHome}";
in
{
  home.packages =
    if pkgs.stdenv.isLinux then
      [
        (pkgs.nixpaks.cherry-studio.override {
          dotDir = dotDir;
          extraMnts = [ "Desktop" ];
        })
      ]
    else
      [ pkgs.cherry-studio ];
  mergetools.cherry-studio-config = {
    target = "${electronBase}/CherryStudio/config.json";
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
