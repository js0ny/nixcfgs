{
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.desktop.dm;
in
# https://nixpk.gs/pr-tracker.html?pr=523948
lib.mkIf (config.nixdots.desktop.enable && cfg == "gdm") {
  services.displayManager.gdm = {
    enable = true;
  };
}
