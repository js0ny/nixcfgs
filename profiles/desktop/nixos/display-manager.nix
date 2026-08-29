{
  lib,
  config,
  inputs,
  ...
}:
let
  loginBg = inputs.bindeps + "/wallpaper/login.jpg";
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
    ly.enable = enableDM "ly";
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
