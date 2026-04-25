{
  config,
  lib,
  pkgs,
  ...
}:
let
  apps = config.nixdots.apps;
  platform = config.nixdots.core.platform;
  textMimes = [
    "text/plain"
    "text/x-csrc" # .c
    "text/x-chdr" # .h
    "text/javascript"
    "text/x-python"
    "application/yaml" # .yaml, .yml
    "text/x-patch" # .patch .diff
    "text/x-devicetree-source" # .dts
    "text/x-nix" # .nix
    "text/x-pdx-descriptor" # .mod
    "text/csv"
    "text/markdown"
    "application/vnd.kde.kxmlguirc"
    "application/atom+xml" # .atom
  ];
  webpageMimes = [
    "text/html"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
  ];
  mkAssoc =
    app: mimes:
    builtins.listToAttrs (
      map (mime: {
        name = mime;
        value = app;
      }) mimes
    );
in
{
  home.sessionVariables.TERMINAL = "xdg-terminal-exec";
  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [
        apps.terminal.desktop
      ];
    };
  };
  xdg.configFile."mimeapps.list".force = true;
  xdg.mime.enable = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = apps.fileManager.gui.desktop;
    }
    // mkAssoc apps.editor.gui.desktop textMimes
    // mkAssoc apps.browser.desktop webpageMimes;
  };

}
