{
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.services.tailscale;
in
lib.mkIf cfg.enable {
  nixdots.darwin.homebrew.casks = [ "tailscale-app" ];
}
