{ config, ... }:
let
  epSelf = config.nixdefs.endpoints.meilisearch;
in
{
  services.meilisearch = {
    enable = true;
    listenAddress = epSelf.bindAddress;
    listenPort = epSelf.port;
    masterKeyFile = config.sops.secrets.meili_master_key.path;
  };
}
