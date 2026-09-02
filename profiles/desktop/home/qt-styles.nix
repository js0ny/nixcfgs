{
  pkgs,
  lib,
  config,
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
    };
  };
}
