{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  vicinae-extensions = inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system};
  wallpaperDir = config.home.customDirs.wallpaper;
in
{
  services.awww = {
    enable = true;
  };
  systemd.user.services.awww = {
    Unit = {
      PartOf = [ "waylandwm-session.target" ];
      After = [ "waylandwm-session.target" ];
    };
    Install.WantedBy = [ "waylandwm-session.target" ];
  };
  programs.vicinae = {
    extensions = with vicinae-extensions; [ awww-switcher ];
    settings.providers = {
      "@sovereign/vicinae-extension-awww-switcher-0" = {
        preferences = {
          toggleVicinaeSetting = true;
          colorGenTool = "none";
          gridRows = "4";
          postProduction = "no";
          showImageDetails = true;
          transitionDuration = "3";
          transitionFPS = "60";
          transitionStep = "90";
          transitionType = "random";
        }
        // (lib.optionalAttrs (wallpaperDir != null) {
          wallpaperPath = wallpaperDir;
        });
      };

    };
  };
  # stylix
  services.hyprpaper.enable = lib.mkForce false;
}
