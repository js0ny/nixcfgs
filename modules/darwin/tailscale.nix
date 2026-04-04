{
  lib,
  config,
  ...
}: let
  cfg = config.nixdots.services.tailscale;
in {
  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
    };
  };
}
