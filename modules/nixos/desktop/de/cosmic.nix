{
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.desktop.de;
in
lib.mkIf (config.nixdots.desktop.enable && builtins.elem "cosmic" cfg) {
  services.desktopManager.cosmic.enable = true;
}
