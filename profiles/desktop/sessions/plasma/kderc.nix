{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    kdePackages.kconfig
  ];
  programs.plasma = {
    enable = true;
    workspace = {
      iconTheme = config.nixdots.style.icon.dark;
      lookAndFeel = "stylix";
    };
    configFile = {
      kiorc = {
        Confirmations = {
          ConfirmDelete = true;
          ConfirmEmptyTrash = true;
          ConfirmTrash = false;
        };
        "Executable scripts".behaviourOnLaunch = "alwaysAsk";
      };
      kdeglobals = {
        General = {
          TerminalApplication = lib.getExe config.js0ny.apps.terminal.package;
          TerminalService = config.js0ny.apps.terminal.desktop;
        };
        KDE = {
          ShowDeleteCommand = false;
          widgetStyle = config.nixdots.style.icon.dark;
        };
        PreviewSettings = {
          EnableRemoteFolderThumbnail = false;
          MaximumRemoteSize = 0;
        };
        Icons.Theme = config.nixdots.style.icon.dark;
        Shortcuts = {
          Help = "";
          Preferences = "Ctrl+,; Ctrl+Shift+,";
          WhatsThis = "";
        };
        KScreen = {
          XwaylandClientsScale = false;
        };
      };
      kwinrc = {
        ".org.kde.kdecoration2" = {
          ButtonsOnLeft = "MSF";
          library = "org.kde.breeze";
          theme = "Breeze";
        };
      };
      baloofilerc = {
        General = {
          dbVersion = 2;
          "exclude folders" = "$HOME/";
          folders = lib.concatStringsSep "," (
            lib.mapAttrsToList (name: _: "$HOME/${name}") (
              lib.filterAttrs (_: dir: dir.enable && dir.pin) config.home.directories
            )
          );
          "only basic indexing" = false;
        };
      };
      arkrc.General.defaultOpenAction = "Open";
    };
  };
}
