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
  xdg.configFile = builtins.listToAttrs (
    map (name: {
      name = "bat/syntaxes/${name}";
      value.source = ../filetype/sublime-syntax/${name};
    }) (builtins.attrNames (builtins.readDir ../filetype/sublime-syntax))
  );
}
