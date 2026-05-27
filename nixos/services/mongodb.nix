{
  pkgs,
  config,
  lib,
  ...
}:
let
  epSelf = config.nixdefs.endpoints.mongodb;
in
{
  sops.secrets = {
    mongodb_password = { };
  };
  services.mongodb = {
    enable = true;
    # The default mongodb package does not provide pre-compiled binaries
    package = lib.mkDefault pkgs.mongodb-ce;
    enableAuth = lib.mkDefault false;
    bind_ip = epSelf.bindAddress;
    initialRootPasswordFile = config.sops.secrets.mongodb_password.path;
  };
}
