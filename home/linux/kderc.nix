{ config, lib, ... }:
{
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
          TerminalApplication = lib.getExe config.nixdots.apps.terminal.package;
          TerminalService = config.nixdots.apps.terminal.desktop;
        };
        KDE.ShowDeleteCommand = false;
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
      };
    };
  };

}
