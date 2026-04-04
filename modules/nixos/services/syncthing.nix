{
  config,
  lib,
  ...
}: let
  cfg = config.nixdots.services.syncthing;
in
  lib.mkIf cfg.enable {
    services.syncthing.enable = true;
  }
