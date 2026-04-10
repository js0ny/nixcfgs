{
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.desktop.dm;
in
lib.mkIf (config.nixdots.desktop.enable && cfg == "ly") {
  services.displayManager.ly.enable = true;
}
