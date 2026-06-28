{
  flake.nixosModules.meilisearch =
    { config, secrets, ... }:
    let
      epSelf = config.nixdefs.endpoints.meilisearch;
    in
    {
      sops.secrets = {
        meili_master_key = {
          sopsFile = secrets + /meilisearch.yaml;
        };
      };
      services.meilisearch = {
        enable = true;
        listenAddress = epSelf.bindAddress;
        listenPort = epSelf.port;
        masterKeyFile = config.sops.secrets.meili_master_key.path;
      };
    };
}
