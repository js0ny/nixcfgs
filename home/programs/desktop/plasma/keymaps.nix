{ ... }:
{
  programs.plasma = {
    hotkeys.commands = {
      "launch-obsidian" = {
        name = "Launch Obsidian";
        key = "Meta+O";
        command = "obsidian";
      };
      "launch-terminal" = {
        name = "Launch Terminal";
        key = "Meta+Return";
        command = "xdg-terminal-exec";
      };
    };
    configFile = {
      spectaclerc = {
        ImageSave.translatedScreenshotsFolder = "Screenshots";
        VideoSave.translatedScreencastsFolder = "Screencasts";
      };
      kdeglobals.Shortcuts = {
        Help = "";
        Preferences = "Ctrl+,; Ctrl+Shift+,";
        WhatsThis = "";
      };
    };
    shortcuts = {
      "KDE Keyboard Layout Switcher"."Switch to Last-Used Keyboard Layout" = [ ];
      "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = [ ];
      kaccess."Toggle Screen Reader On and Off" = [ ];
      ksmserver."Lock Session" = "Screensaver";
      kwin = {
        "Edit Tiles" = [ ];
        Expose = [ ];
        ExposeAll = "Meta+W";
        ExposeClass = [ ];
        ExposeClassCurrentDesktop = [ ];
        "Grid View" = [ ];
        Overview = [ ];
        "Walk Through Windows" = "Alt+Tab";
        "Walk Through Windows (Reverse)" = "Alt+Shift+Tab";
        "Walk Through Windows of Current Application" = "Alt+`";
        "Walk Through Windows of Current Application (Reverse)" = "Alt+~";
        "Window Close" = [
          "Meta+Q"
          "Alt+F4"
        ];
      };
      plasmashell = {
        cycle-panels = [ ];
        cycleNextAction = [ ];
        cyclePrevAction = [ ];
        edit_clipboard = [ ];
        "manage activities" = [ ];
      };
      "services/org.kde.krunner.desktop" = {
        RunClipboard = [ ];
        _launch = [
          "Search"
          "Alt+Space"
        ];
        ShowOSD = [ ];
      };
      "services/org.kde.plasma.emojier.desktop"._launch = "Meta+.";
      "services/org.kde.spectacle.desktop".CurrentMonitorScreenShot = [ ];
      "services/org.kde.spectacle.desktop".OpenWithoutScreenshot = [ ];
    };
  };
}
