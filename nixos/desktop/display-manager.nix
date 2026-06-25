{
  config,
  inputs,
  ...
}:
let
  loginBg = inputs.bindeps + "/wallpaper/login.jpg";
  cfg = config.nixdots.desktop.dm;
  enableDM = displayManagerName: displayManagerName == cfg;
in
{
  services.displayManager = {
    defaultSession = builtins.head config.nixdots.desktop.session;
    autoLogin = {
      enable = config.nixdots.desktop.autoLogin;
      user = config.nixdots.user.name;
    };
    gdm.enable = enableDM "gdm";
    ly.enable = enableDM "ly";
    plasma-login-manager = {
      enable = enableDM "plasma-login-manager";
      settings = {
        Greeter.PreselectedSession = "niri.desktop";
        Autologin.User = config.nixdots.user.name;
      };
    };
    cosmic-greeter.enable = enableDM "cosmic-greeter";
    sddm = {
      enable = enableDM "sddm";
      wayland.enable = true;
      enableHidpi = true;
      thyx.enable = true;
      settings = {
        Theme = {
          CursorSize = config.stylix.cursor.size;
          CursorTheme = config.stylix.cursor.name;
        };
      };
    };
  };
}
