{
  config,
  lib,
  pkgs,
  ...
}:
let
  apps = config.nixdots.apps;
  duti = "${pkgs.duti}/bin/duti";
  mkDutiCommands = app: extensions: map (ext: "${duti} -s ${app} ${ext} all") extensions;
  dutiMaps = {
    "${apps.editor.gui.bundleIdentifier}" = [
      "md"
      "json"
      "js"
      "txt"
      "xml"
      "nix"
      "yaml"
      "lock"
      "atom"
    ];
    #     "${apps.browser.bundleIdentifier}" = ["html" "htm"];
  };
in
{
  home.sessionVariables.TERMINAL = apps.terminal.exe;
  home.packages = [
    pkgs.duti
  ];
  home.activation.setOSXCommonDefaultApps = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${lib.concatStringsSep "\n" (lib.flatten (lib.mapAttrsToList mkDutiCommands dutiMaps))}
  '';
}
