{
  pkgs,
  lib,
  myLib,
  config,
  inputs,
  ...
}:
let
  d = config.nixdots;
  _locale = d.core.locales.guiLocale;
  locale = myLib.toHanScript _locale;
  wallpaperDir = config.home.customDirs.wallpaper;
in
{
  imports = [
    inputs.self.homeModules.wm-components
  ];
  systemd.user.services.noctalia = {
    Unit = {
      PartOf = lib.mkForce [ "waylandwm-session.target" ];
      After = lib.mkForce [ "waylandwm-session.target" ];
    };
    Install.WantedBy = lib.mkForce [ "waylandwm-session.target" ];
  };
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = {
      backdrop.enabled = true;
      brightness.enable_ddcutil = true;
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
          builtin_ids = [
            "hyprland"
            "niri"
            "labwc"
            "mango"
            "scroll"
            "sway"
          ];
          community_ids = [
            "vicinae"
          ];
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
  services.hyprpaper.enable = lib.mkForce false;
  stylix.targets = {
    vicinae.enable = false;
  };
}
