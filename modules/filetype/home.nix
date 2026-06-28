{
  lib,
  pkgs,
  config,
  ...
}:
let
  apps = config.nixdots.apps;
in
{
  imports = [
    ./mimedb.nix
    ./libmagic.nix
  ];

  home.sessionVariables = {
    EDITOR = apps.editor.tui.exe;
    VISUAL = apps.editor.tui.exe;
    BROWSER = apps.browser.exe;
  };
}
