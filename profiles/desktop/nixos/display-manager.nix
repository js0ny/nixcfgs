{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  loginBg = inputs.bindeps + "/wallpaper/login.jpg";
  lyBlackhole = pkgs.fetchurl {
    url = "https://codeberg.org/fairyglade/ly-community/raw/commit/2f22cfaf7d17598c8f60f562d56e16d74b6c99ab/animations/dur/blackhole-smooth-240x67.dur";
    hash = "sha256-wo3FzPtngCsg/bRSDTYHQqKnMp4vY+Btm14vakJERBU=";
  };
  cfg = config.js0ny.desktop.displayManager;
  enableDM = displayManagerName: displayManagerName == cfg;
  s = builtins.head config.js0ny.desktop.session;
  defaultSession = if s == "hyprland" then "hyprland-uwsm" else s;
in
{
  services.displayManager = {
    inherit defaultSession;
    autoLogin = {
      enable = config.js0ny.desktop.autoLogin;
      user = config.js0ny.user.name;
    };
    gdm.enable = enableDM "gdm";
    ly = {
      enable = enableDM "ly";
      x11Support = false;
      # https://codeberg.org/fairyglade/ly/src/branch/master/res/config.lua
      settings = {
        animation = "dur_file";
        dur_file_path = toString lyBlackhole;
        dur_offset_alignment = "center";
        full_color = true;
        # Don't show shell session
        shell = false;
        vi_mode = true;
        vi_default_mode = "normal";
        # Disable xinitrc session
        xinitrc = null;
        auto_login_session = defaultSession;
        auto_login_user = config.js0ny.user.name;
      };
    };
    plasma-login-manager = {
      enable = enableDM "plasma-login-manager";
      settings = {
        Greeter.PreselectedSession = "${defaultSession}.desktop";
        Autologin.User = config.js0ny.user.name;
      };
    };
    cosmic-greeter.enable = enableDM "cosmic-greeter";
    sddm = {
      enable = lib.mkForce (enableDM "sddm");
      wayland.enable = true;
      enableHidpi = true;
      settings = {
        Theme = {
          CursorSize = config.stylix.cursor.size;
          CursorTheme = config.stylix.cursor.name;
        };
      };
    };
    regreet.enable = enableDM "regreet";
  };
}
