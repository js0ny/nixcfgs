{
  flake.nixosModules.mongodb =
    {
      pkgs,
      config,
      lib,
      secrets,
      ...
    }:
    let
      epSelf = config.nixdefs.endpoints.mongodb;
      inherit (config.services.mongodb) user;
      group = user;
    in
    {
      sops.secrets = {
        mongodb_password = {
          sopsFile = secrets + "/mongodb.yaml";
        };
      };
      services.mongodb = {
        enable = true;
        # The default mongodb package does not provide pre-compiled binaries
        package = lib.mkDefault pkgs.mongodb-ce;
        enableAuth = lib.mkDefault false;
        bind_ip = epSelf.bindAddress;
        initialRootPasswordFile = config.sops.secrets.mongodb_password.path;
      };
      js0ny.persist.stores.state.directories = [
        {
          directory = config.services.mongodb.dbpath;
          inherit user group;
        }
      ];
    };
}
