{
  config,
  pkgs,
  lib,
  secrets,
  ...
}:
let
  dbname = "nextcloud";
  dbuser = "nextcloud";
  ep = config.nixdefs.endpoints;
  url = ep.nextcloud.domain;
in
{
  sops.secrets.nextcloud_admin_pass = {
    sopsFile = secrets + /nextcloud.yaml;
  };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud33;
    hostName = url;
    autoUpdateApps.enable = true;
    https = true;
    caching.redis = true;
    config = {
      adminpassFile = config.sops.secrets.nextcloud_admin_pass.path;
      dbtype = "pgsql";
      dbname = dbname;
      dbuser = dbuser;
      dbhost = "/run/postgresql";
      adminuser = "admin";
    };
    database.createLocally = true;
    settings = {
      default_phone_region = "GB";
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ dbname ];
    ensureUsers = [
      {
        name = dbuser;
        ensureDBOwnership = true;
      }
    ];
  };

  services.nginx.virtualHosts = lib.mkIf (url != null) {
    ${url} = {
      forceSSL = true;
      enableACME = true;
    };
  };
}
