{ lib, ... }:
let
  inherit (lib) mkOption mkEnableOption;
in
{
  options.nixdots.features = {
    enable = mkEnableOption "Features";
    preferGtk = mkEnableOption "Prefer GTK applications over Qt ones.";
    preferQt = mkEnableOption "Prefer Qt applications over GTK ones.";
    media = {
      obs-studio.enable = mkEnableOption "Enable OBS Studio for screen recording and streaming.";
      mpv = {
        enable = mkEnableOption "Enable MPV media player.";
        enableNativeFrontend = mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable MPV's native frontend on different platforms. This may provide better eye candies and integration, but may have some limitations compared to the default frontend.";
        };
      };
    };
  };
}
