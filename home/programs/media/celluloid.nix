{
  pkgs,
  lib,
  config,
  ...
}:
let
  feat = config.nixdots.features;
  cfg = feat.mpv;
in
lib.mkIf (pkgs.stdenv.isLinux && cfg.enable && cfg.enableNativeFrontend && feat.preferGtk) {
  # MPV GTK4 frontend
  imports = [ ./mpv.nix ]; # Include MPV configuration
  home.packages = [ pkgs.celluloid ];
  dconf.settings = {
    "io/github/celluloid-player/celluloid" = {
      mpv-config-enable = true;
      mpv-input-config-enable = true;
      mpv-config-file = "file://${config.xdg.configHome}/mpv/mpv.conf";
      mpv-input-config-file = "file://${config.xdg.configHome}/mpv/input.conf";
    };
  };
}
