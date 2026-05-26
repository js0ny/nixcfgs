{
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.desktop.dm;
in
lib.mkIf (config.nixdots.desktop.enable && cfg == "cosmic-greeter") {
  services.displayManager.cosmic-greeter.enable = true;
}
