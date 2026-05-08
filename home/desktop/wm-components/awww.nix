{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  vicinae-extensions = inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system};
  inherit (lib) mkDefault;
  wallpaperDir = config.home.customDirs.wallpaper;
in
{
  services.awww = {
    enable = true;
  };
  systemd.user.services.awww.Install.WantedBy = [ "niri.service" ];
  programs.vicinae = {
    extensions = with vicinae-extensions; [ awww-switcher ];
    settings.providers = {
      "@sovereign/vicinae-extension-awww-switcher-0" = {
        preferences = {
          toggleVicinaeSetting = true;
          colorGenTool = mkDefault "none";
          gridRows = mkDefault "4";
          postProduction = mkDefault "no";
          showImageDetails = mkDefault true;
          transitionDuration = mkDefault "3";
          transitionFPS = mkDefault "60";
          transitionStep = mkDefault "90";
          transitionType = mkDefault "random";
        }
        // (lib.optionalAttrs (wallpaperDir != null) {
          wallpaperPath = wallpaperDir;
        });
      };

    };
  };
}
