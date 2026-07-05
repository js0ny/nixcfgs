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
    in
    {
      sops.secrets = {
        mongodb_password = {
          sopsFile = secrets + /mongodb.yaml;
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
      nixdots.persist.system.directories = [
        {
          directory = config.services.mongodb.dbpath;
          user = "mongodb";
          group = "mongodb";
        }
      ];
    };
}
