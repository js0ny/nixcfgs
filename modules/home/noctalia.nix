{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
let
  d = config.nixdots;
  enable = d.desktop.wmShell == "noctalia";
  basepkg = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
  # https://github.com/noctalia-dev/noctalia-shell/issues/1440#issuecomment-3872048063
  pkg = pkgs.runCommand "noctalia-shell-wrapped" { nativeBuildInputs = [ pkgs.makeWrapper ]; } ''
    mkdir -p $out/bin
    makeWrapper ${lib.getExe basepkg} $out/bin/noctalia-shell \
      --set QT_QPA_PLATFORMTHEME "qt6ct" \
      --set-default QS_ICON_THEME ${d.style.icon.dark};
  '';
  geo = d.geo;
  clockWidget = {
    clockColor = "secondary";
    customFont = "";
    formatHorizontal = "HH:mm:ss ddd; MMM dd";
    formatVertical = "HH mm - dd MM";
    id = "Clock";
    tooltipFormat = "yyyy ddd; MMM dd t HH:mm:ss";
    useCustomFont = false;
  };
  trayWidget = {
    blacklist = [ ];
    chevronColor = "none";
    colorizeIcons = false;
    drawerEnabled = true;
    hidePassive = false;
    id = "Tray";
    pinned = [
      "Rime"
    ];
  };
  batteryWidget = {
    deviceNativePath = "__default__";
    displayMode = "graphic";
    hideIfIdle = false;
    hideIfNotDetected = true;
    id = "Battery";
    showNoctaliaPerformance = true;
    showPowerProfiles = true;
  };
  notificationWidget = {
    hideWhenZero = true;
    hideWhenZeroUnread = false;
    iconColor = "none";
    id = "NotificationHistory";
    showUnreadBadge = true;
    unreadBadgeColor = "primary";
  };
  volumeWidget = {
    displayMode = "onhover";
    iconColor = "none";
    id = "Volume";
    middleClickCommand = "pwvucontrol || pavucontrol";
    textColor = "none";
  };
  brightnessWidget = {
    applyToAllMonitor = false;
    displayMode = "onhover";
    iconColor = "none";
    id = "Brightness";
    textColor = "none";
  };
  controlCenterWidget = {

    colorizeSystemIcon = "secondary";
    customIconPath = "";
    enableColorization = true;
    icon = "noctalia";
    id = "ControlCenter";
    useDistroLogo = false;
  };
  workspaceWidget = {

    characterCount = 2;
    colorizeIcons = false;
    emptyColor = "secondary";
    enableScrollWheel = true;
    focusedColor = "primary";
    followFocusedScreen = false;
    fontWeight = "bold";
    groupedBorderOpacity = 1;
    hideUnoccupied = false;
    iconScale = 0.8;
    id = "Workspace";
    labelMode = "index";
    occupiedColor = "secondary";
    pillSize = 0.6;
    showApplications = true;
    showApplicationsHover = false;
    showBadge = true;
    showLabelsOnlyWhenOccupied = true;
    unfocusedIconsOpacity = 1;
  };
  launcherWidget = {
    colorizeSystemIcon = "none";
    customIconPath = "";
    enableColorization = false;
    icon = "rocket";
    id = "Launcher";
    useDistroLogo = true;
  };
  systemMonitorWidget = {
    compactMode = true;
    diskPath = "/";
    iconColor = "none";
    id = "SystemMonitor";
    showCpuCores = false;
    showCpuFreq = false;
    showCpuTemp = true;
    showCpuUsage = true;
    showDiskAvailable = false;
    showDiskUsage = false;
    showDiskUsageAsPercent = false;
    showGpuTemp = false;
    showLoadAverage = false;
    showMemoryAsPercent = false;
    showMemoryUsage = true;
    showNetworkStats = false;
    showSwapUsage = false;
    textColor = "none";
    useMonospaceFont = true;
    usePadding = false;
  };
  activeWindowWidget = {
    id = "activeWindow";
  };
  mediaMiniWidget = {
    compactMode = true;
    hideMode = "hidden";
    id = "MediaMini";
    maxWidth = 145;
    panelShowAlbumArt = true;
    scrollingMode = "hover";
    showAlbumArt = true;
    showArtistFirst = true;
    showProgressRing = true;
    showVisualizer = false;
    textColor = "secondary";
    useFixedWidth = false;
    visualizerType = "wave";
  };
in
lib.mkIf enable {
  home.sessionVariables = {
    # https://github.com/noctalia-dev/noctalia-shell/issues/281#issuecomment-3290870607
    QS_ICON_THEME = d.style.icon.dark;
  };
  home.packages = with pkgs; [
    qt6Packages.qt6ct
  ];
  # Reference:
  # Dump current config:
  #   noctalia-shell ipc call state all | jq .settings
  programs.noctalia-shell = {
    enable = true;
    package = # lib.mkForce
      pkg;
    settings = {
      general = {
        avatarImage = lib.mkDefault d.user.avatar;
        # language = d.core.locales.guiLocale;
        telemetryEnabled = lib.mkForce false;
        keybinds = {
          keyUp = [ "Up" ];
        };
        language = config.nixdots.core.locales.guiLocale;
      };
      wallpaper = {
        enabled = lib.mkDefault true;
        overviewEnabled = lib.mkDefault true;
        showHiddenFiles = lib.mkDefault true;
        viewMode = lib.mkDefault "recursive";
      }
      // (lib.optionalAttrs (d.style.wallpaperDir != null) {
        directory = d.style.wallpaperDir;
      });
      location = {
        monthBeforeDay = true;
        weatherEnabled = true;
        useFahrenheit = false;
        use12hourFormat = lib.mkDefault false;
        showWeekNumberInCalendar = lib.mkDefault true;
        showCalendarEvents = true;
        showCalendarWeather = true;
        analogClockInCalendar = lib.mkDefault false;
        firstDayOfWeek = lib.mkDefault 1;
      }
      // (lib.optionalAttrs (geo.city != null) {
        name = lib.mkDefault geo.city;
        autoLocate = false;
      });
      controlCenter = {
        diskPath = "/";
      };
      bar = {
        position = lib.mkDefault "top";
        density = lib.mkDefault "default";
        widgets = lib.mkDefault {
          left = [
            launcherWidget
            systemMonitorWidget
            activeWindowWidget
            mediaMiniWidget
          ];
          center = [ workspaceWidget ];
          right = [
            trayWidget
            notificationWidget
            batteryWidget
            volumeWidget
            brightnessWidget
            clockWidget
            controlCenterWidget
          ];
        };
      };
      appLauncher = {
        enableClipboardHistory = lib.mkDefault false;
        autoPasteClipboard = lib.mkDefault false;
        clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
        clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
        terminalCommand = lib.mkDefault "xdg-terminal-exec";
        customLauncherPrefix = lib.mkDefault false;
      };
    };
  };
  nixdots.desktop.niri.extraConfig = /* kdl */ ''
    window-rule {
      geometry-corner-radius 20

      // Clips window contents to the rounded corner boundaries.
      clip-to-geometry true
    }

    debug {
      // Allows notification actions and window activation from Noctalia.
      honor-xdg-activation-with-invalid-serial
    }

    layer-rule {
      match namespace="^noctalia-overview*"
      place-within-backdrop true
    }

    spawn-at-startup "noctalia-shell"
  '';
}
