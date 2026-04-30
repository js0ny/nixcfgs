{ lib, config, ... }:
let
  xdgDirs = config.xdg.userDirs;
  inherit (lib) mkOption;
  inherit (lib.types) str nullOr;
in
{
  options.home.customDirs = {
    wallpaper = mkOption {
      type = nullOr str;
      default = "${xdgDirs.pictures}/Wallpaper";
    };
    screenshots = mkOption {
      type = str;
      default = "${xdgDirs.pictures}/Screenshots";
    };
    screencasts = mkOption {
      type = nullOr str;
      default = "${xdgDirs.videos}/Screencasts";
    };
  };
}
