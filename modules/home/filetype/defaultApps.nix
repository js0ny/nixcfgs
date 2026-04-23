{
  config,
  lib,
  pkgs,
  ...
}:
let
  apps = config.nixdots.apps;
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
  config = lib.mkMerge [
    {
      home.sessionVariables = {
        EDITOR = apps.editor.tui.exe;
        VISUAL = apps.editor.tui.exe;
        BROWSER = apps.browser.exe;
      };
    }
    (lib.mkIf pkgs.stdenv.isLinux {
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

      programs.plasma.configFile = {
        kdeglobals = {
          General = {
            TerminalApplication = lib.getExe config.nixdots.apps.terminal.package;
            TerminalService = config.nixdots.apps.terminal.desktop;
          };
        };
      };
    })

    (lib.mkIf pkgs.stdenv.isDarwin {
      home.sessionVariables.TERMINAL = apps.terminal.exe;
      home.packages = [
        pkgs.duti
      ];
      home.activation.setOSXCommonDefaultApps = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ${lib.concatStringsSep "\n" (lib.flatten (lib.mapAttrsToList mkDutiCommands dutiMaps))}
      '';
    })
  ];
}
