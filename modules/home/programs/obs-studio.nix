{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.features.media.obs-studio;
in
lib.mkIf (cfg.enable && pkgs.stdenv.isLinux) {
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      input-overlay
      obs-vkcapture
    ];
  };
}
