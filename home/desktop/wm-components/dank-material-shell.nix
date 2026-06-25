{
  config,
  lib,
  ...
}:
let
  xdg-config = config.xdg.configHome;
  d = config.nixdots;
  enable = d.desktop.wm.shell == "dank-material-shell";
  wallpaperDir = config.home.customDirs.wallpaper;
  geo = d.geo;
  locale = builtins.replaceStrings [ "-" ] [ "_" ] d.core.locales.guiLocale;
  user = config.home.username;
  inherit (lib) mkDefault;
in
lib.mkIf enable {
  home.sessionVariables = {
    DMS_DISABLE_POLKIT = "1";
  };

  systemd.user.services.dms = {
    Unit = {
      PartOf = lib.mkForce [ "waylandwm-session.target" ];
      After = lib.mkForce [ "waylandwm-session.target" ];
    };
    Install.WantedBy = lib.mkForce [ "waylandwm-session.target" ];
  };

  programs.dank-material-shell = {
    enable = true;
    systemd = {
      enable = true;
      restartIfChanged = true;
    };

    session = {
      wallpaperPath = mkDefault "${wallpaperDir}/current.jpg";
      nightModeUseIPLocation = false;
      latitude = geo.latitude;
      longitude = geo.longitude;
      weatherCoordinates = "${toString geo.latitude},${toString geo.longitude}";
      locale = mkDefault locale;
      timeLocale = mkDefault locale;
      hiddenTrayIds = [
        "chrome_status_icon_1::Feishin"
        "ROG Control Center"
        "indicator-solaar" # Logitech devices
      ];
    };
    settings = {
      # Theme
      currentThemeName = "custom";
      currentThemeCategory = "generic";
      syncModeWithPortal = true;
      iconTheme = "System Default";
      cursorSettings = {
        theme = "System Default";
        size = config.stylix.cursor.size;
      };
      # wallpaper
      wallpaperFillMode = "Fill";
      blurredWallpaperLayer = false;
      blurWallpaperOnOverview = true;
      # workspace
      showWorkspaceIndex = true;
      showWorkspaceName = false;
      showWorkspacePadding = false;
      workspaceScrolling = false;
      showWorkspaceApps = true;
      workspaceDragReorder = true;
      maxWorkspaceIcons = 99;
      workspaceAppIconSizeOffset = 0;
      groupWorkspaceApps = true;
      workspaceFollowFocus = false;
      # Media Player
      waveProgressEnabled = true;
      scrollTitleEnabled = true;
      mediaAdaptiveWidthEnabled = true;
      audioVisualizerEnabled = true;
      audioScrollMode = "song";
      audioWheelScrollAmount = 5;
      muxType = if config.programs.zellij.enable then "zellij" else "tmux";
      # clock
      desktopClockShowDate = true;
      desktopClockShowAnalogNumbers = false;
      desktopClockShowAnalogSeconds = true;
      firstDayOfWeek = 1;
      showWeekNumber = true;
      # launcher
      launcherLogoMode = "os";
      launcherLogoColorOverride = "primary";
      # OSD
      osdAlwaysShowValue = true;
      osdPosition = 2;
      osdVolumeEnabled = true;
      osdMediaVolumeEnabled = true;
      osdMediaPlaybackEnabled = true;
      osdBrightnessEnabled = true;
      osdIdleInhibitorEnabled = true;
      osdMicMuteEnabled = true;
      osdCapsLockEnabled = true;
      osdPowerProfileEnabled = true;
      osdAudioOutputEnabled = true;
      barConfigs = [
        {
          id = "default";
          name = "Main Bar";
          enabled = true;
          position = 0;
          screenPreferences = [
            "all"
          ];
          showOnLastDisplay = true;
          leftWidgets = [
            "launcherButton"
            {
              id = "music";
              enabled = true;
            }
          ];
          centerWidgets = [
            {
              id = "workspaceSwitcher";
              enabled = true;
            }
          ];
          rightWidgets = [
            {
              id = "notificationButton";
              enabled = true;
            }
            {
              id = "systemTray";
              enabled = true;
              trayUseInlineExpansion = true;
            }
            {
              id = "battery";
              enabled = true;
            }
            {
              id = "controlCenterButton";
              enabled = true;
              showAudioPercent = false;
              showBrightnessIcon = false;
              showBrightnessPercent = false;
              showBatteryIcon = false;
            }
            {
              id = "clock";
              enabled = true;
              clockCompactMode = false;
            }
          ];
          spacing = 4;
          innerPadding = 4;
          bottomGap = 0;
          transparency = 1;
          widgetTransparency = 1;
          squareCorners = false;
          noBackground = false;
          gothCornersEnabled = false;
          gothCornerRadiusOverride = false;
          gothCornerRadiusValue = 12;
          borderEnabled = false;
          borderColor = "surfaceText";
          borderOpacity = 1;
          borderThickness = 1;
          fontScale = 1;
          autoHide = false;
          autoHideDelay = 250;
          openOnOverview = false;
          visible = true;
          popupGapsAuto = true;
          popupGapsManual = 4;
        }
      ];
      appIdSubstitutions = [
        {
          pattern = "GameConqueror.py";
          replacement = "GameConqueror";
          type = "exact";
        }
        {
          pattern = "Hermes";
          replacement = "hermes-agent";
          type = "exact";
        }
      ];
    };
  };
  wayland.windowManager.niri.extraConfig = /* kdl */ ''
    include "${xdg-config}/niri/dms/alttab.kdl"
    include "${xdg-config}/niri/dms/binds.kdl"
    include "${xdg-config}/niri/dms/colors.kdl"
    include "${xdg-config}/niri/dms/cursor.kdl"
    include "${xdg-config}/niri/dms/outputs.kdl"
    include "${xdg-config}/niri/dms/windowrules.kdl"
    include "${xdg-config}/niri/dms/wpblur.kdl"
  '';

  systemd.user.tmpfiles.rules = [
    "f ${xdg-config}/niri/dms/alttab.kdl 0644 ${user} users -"
    "f ${xdg-config}/niri/dms/binds.kdl 0644 ${user} users -"
    "f ${xdg-config}/niri/dms/colors.kdl 0644 ${user} users -"
    "f ${xdg-config}/niri/dms/cursor.kdl 0644 ${user} users -"
    "f ${xdg-config}/niri/dms/outputs.kdl 0644 ${user} users -"
    "f ${xdg-config}/niri/dms/windowrules.kdl 0644 ${user} users -"
    "f ${xdg-config}/niri/dms/wpblur.kdl 0644 ${user} users -"
  ];
  # stylix
  services.hyprpaper.enable = lib.mkForce false;
}
