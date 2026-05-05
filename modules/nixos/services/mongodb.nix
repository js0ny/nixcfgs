{
  pkgs,
  config,
  lib,
  ...
}:
let
  ep = config.nixdefs.endpoints.mongodb;
in
lib.mkIf (config.services.librechat.enable) {
  services.mongodb = {
    enable = true;
    # The default mongodb package does not provide pre-compiled binaries
    package = lib.mkDefault pkgs.mongodb-ce;
    enableAuth = lib.mkDefault false;
    bind_ip = ep.bindAddress;
  };
  environment.systemPackages = with pkgs; [ mongosh ];
}
