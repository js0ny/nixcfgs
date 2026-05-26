{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.programs.obs-studio;
in
lib.mkIf (cfg.enable && pkgs.stdenv.isLinux) {
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      input-overlay
    ];
  };
}
