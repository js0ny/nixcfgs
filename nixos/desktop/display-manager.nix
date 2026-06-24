{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  loginBg = inputs.bindeps + "/wallpaper/login.jpg";
  cfg = config.nixdots.desktop.dm;
  enableDM = displayManagerName: displayManagerName == cfg;
  custom-sddm-astronaut =
    (pkgs.sddm-astronaut.override {
      embeddedTheme = "hyprland_kath";
      themeConfig = {
        HeaderTextColor = "#d5c4a1";
        Background = "Backgrounds/custom.png";
      };
    }).overrideAttrs
      (oldAttrs: {
        installPhase = oldAttrs.installPhase + ''
          chmod u+w $out/share/sddm/themes/sddm-astronaut-theme/Backgrounds/
          cp ${loginBg} \
            $out/share/sddm/themes/sddm-astronaut-theme/Backgrounds/custom.png
        '';
      });
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
      settings.Theme.Current = "sddm-astronaut-theme";
      extraPackages = [ custom-sddm-astronaut ];
    };
  };
  environment.systemPackages = lib.optionals (enableDM "sddm") [
    custom-sddm-astronaut
  ];
}
