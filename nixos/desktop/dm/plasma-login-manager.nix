{
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.desktop.dm;
in
lib.mkIf (config.nixdots.desktop.enable && cfg == "plasma-login-manager") {
  services.displayManager.plasma-login-manager = {
    enable = true;
  };
}
