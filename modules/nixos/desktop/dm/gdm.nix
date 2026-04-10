{
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.desktop.dm;
in
lib.mkIf (config.nixdots.desktop.enable && cfg == "gdm") {
  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };
}
