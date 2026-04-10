{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.packages = [
    pkgs.bruno
    pkgs.bruno-cli
  ];
  mergetools.bruno-preferences = {
    target = "${config.home.homeDirectory}/.config/bruno/preferences.json";
    format = "json";
    settings = {
      preferences = {
        font = {
          codeFont = "${config.stylix.fonts.monospace.name}";
          codeFontSize = 14;
        };
      };
    };
  };
  nixdots.persist.home = {
    directories = [
      ".config/bruno"
    ];
  };
}
