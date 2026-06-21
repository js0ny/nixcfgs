{ lib, config, ... }:
let
  cfg = config.nixdots.desktop.de;
in
lib.mkIf (config.nixdots.desktop.enable && builtins.elem "mangowc" cfg) {
  programs.mangowc.enable = true;

  programs.uwsm = {
    enable = true;
  };

  xdg.portal.enable = true;

}
