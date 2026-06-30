{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf config.nixdots.server.enable {
}
