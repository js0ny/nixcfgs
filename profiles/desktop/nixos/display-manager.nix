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

  userName = config.js0ny.user.name;
  greetdUser = config.services.greetd.settings.default_session.user;
  greetdGroup =
    if config.users.users.${greetdUser}.group != "" then
      config.users.users.${greetdUser}.group
    else
      "greeter";

  # ReGreet keys its saved sessions by the .desktop `Name`, not by the session id.
  sessionDisplayNames = {
    hyprland = "Hyprland (uwsm-managed)";
    niri = "Niri";
    sway = "Sway";
    kde = "Plasma (Wayland)";
    gnome = "GNOME";
    cosmic = "COSMIC";
  };

  # ReGreet's state cache. `builtins.toJSON` is used as a TOML basic string encoder.
  regreetState =
    /* toml */ ''
      last_user = ${builtins.toJSON userName}
    ''
    + lib.optionalString (sessionDisplayNames ? ${s}) /* toml */ ''
      [user_to_last_sess]
      ${builtins.toJSON userName} = ${builtins.toJSON sessionDisplayNames.${s}}
    '';
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

  # ReGreet's state cache is not configurable, and the greeter keeps writing to it while
  # running, so it can only be reset. `f+` truncates and rewrites it on every boot and
  # system activation, while leaving it writable so the last user/session still persists
  # until the next reset.
  systemd.tmpfiles.settings."20-regreet-state" = lib.mkIf (enableDM "regreet") {
    "/var/lib/regreet/state.toml"."f+" = {
      user = greetdUser;
      group = greetdGroup;
      mode = "0644";
      argument = regreetState;
    };
  };
}
