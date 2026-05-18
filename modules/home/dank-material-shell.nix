{
  config,
  lib,
  ...
}:
let
  d = config.nixdots;
  enable = d.desktop.wm.shell == "dank-material-shell";
  wallpaperDir = config.home.customDirs.wallpaper;
  geo = d.geo;
  locale = builtins.replaceStrings [ "-" ] [ "_" ] d.core.locales.guiLocale;
  inherit (lib) mkDefault;
in
lib.mkIf enable {
  home.sessionVariables = {
    DMS_DISABLE_POLKIT = "1";
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
    };
    settings = {
      currentThemeName = "custom";
      currentThemeCategory = "generic";
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
      muxType = if config.programs.zellij.enable then "zellij" else "tmux";
    };
  };
  # stylix
  services.hyprpaper.enable = lib.mkForce false;
}
