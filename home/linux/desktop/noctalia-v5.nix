{ myLib, config, ... }:
let
  d = config.nixdots;
  _locale = d.core.locales.guiLocale;
  locale = myLib.toHanScript _locale;
  wallpaperDir = config.home.customDirs.wallpaper;
in
{
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = {
      backdrop = true;
      shell = {
        lang = locale;
        settings_show_advanced = true;
        avatar_path = "/var/lib/AccountService/icons/${config.home.username}";
        clipboard_enabled = false;
        time_format = "{:%H:%M:%S}";
        screenshot.directory = config.home.customDirs.screenshots;
      };
      theme = {
        templates = {
          builtin_ids = [ "niri" ];
        };
      };
      bar.default = {
        start = [
          "taskbar"
          "media"
        ];
        end = [
          "tray"
          "notifications"
          "network"
          "bluetooth"
          "volume"
          "brightness"
          "battery"
          "session"
          "privacy"
        ];
        margin_edge = 0;
        margin_ends = 0;
        shadow = false;
      };
      dock = {
        enabled = true;
        auto_hide = true;
        reserve_space = false;
        show_dots = true;
      };
      location = {
        latitude = d.geo.latitude;
        longitude = d.geo.longitude;
      };
      calendar.enabled = true;
      wallpaper = {
        transition = [
          "disc"
          "fade"
          "honeycomb"
          "stripes"
          "wipe"
          "zoom"
        ];
        transition_on_startup = true;
        directory = "${wallpaperDir}/";
        default.path = "${wallpaperDir}/default.jpg";
      };
      widget = {
        privacy.hide_inactive = true;
        taskbar.group_by_workspace = true;
        tray = {
          drawer = true;
          pinned = [ "Fcitx" ];
        };
      };
    };
  };
  wayland.windowManager.niri = {
    settings.debug._children = [
      #  Allows notification actions and window activation from Noctalia.
      { "honor-xdg-activation-with-invalid-serial" = true; }
    ];
    extraConfig = /* kdl */ ''
      window-rule {
        // Rounded corners for a modern look.
        geometry-corner-radius 20

        // Clips window contents to the rounded corner boundaries.
        clip-to-geometry true
      }

      layer-rule {
        match namespace="^noctalia-backdrop"
        place-within-backdrop true
      }

      include "${config.xdg.configHome}/niri/noctalia.kdl"
    '';
  };
  systemd.user.tmpfiles.rules = [
    "f ${config.xdg.configHome}/niri/noctalia.kdl 0644 ${config.home.username} users -"
    "f ${config.xdg.stateHome}/noctalia/.setup-complete 0644 ${config.home.username} users -"
  ];
}
