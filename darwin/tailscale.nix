{
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.services.tailscale;
in
lib.mkIf cfg.enable {
  services.tailscale.enable = true;
}
