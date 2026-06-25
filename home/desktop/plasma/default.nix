{
  pkgs,
  config,
  lib,
  myLib,
  ...
}:
let
  cfg = config.nixdots.desktop.session;
in
{
  imports = myLib.scanPaths ./.;
  config = lib.mkIf (config.nixdots.desktop.enable && builtins.elem "kde" cfg) {
    home.packages = with pkgs; [
      # kdePackages.yakuake
      plasmusic-toolbar
      kdePackages.krohnkite
      plasma-plugin-blurredwallpaper
    ];
    programs.plasma = {
      enable = true;
      session.sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
      krunner = {
        position = "center";
      };
      desktop = {
        mouseActions = {
          middleClick = "paste";
          rightClick = "contextMenu";
        };
      };
      workspace = {
        wallpaperCustomPlugin = {
          plugin = "a2n.blur";
        };
      };

    };
    nixdots.persist.home = {
      directories = [
        ".config/kdedefaults"
      ];
    };
    xdg.configFile = {
      "plasma_calendar_alternatecalendar".text = lib.generators.toINI { } {
        General = {
          calendarSystem = "Chinese";
          dateOffset = 0;
        };
      };
      "plasma_calendar_holiday_regions".text = lib.generators.toINI { } {
        General = {
          selectedRegions = "cn_zh-cn,gb-sct_en-gb,hk_zh-cn,gb-eaw_en-gb";
        };
      };
    };
  };
}
