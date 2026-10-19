{ config, ... }:
let
  apps = config.js0ny.apps;
in
{
  home.sessionVariables = {
    EDITOR = apps.editor.tui.exe;
    VISUAL = apps.editor.tui.exe;
    BROWSER = apps.browser.exe;
  };
}
