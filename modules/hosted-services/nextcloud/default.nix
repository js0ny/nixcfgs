{
  flake.nixosModules.nextcloud =
    {
      config,
      pkgs,
      lib,
      secrets,
      utils,
      ...
    }:
    let
      dbname = "nextcloud";
      dbuser = "nextcloud";
      ep = config.nixdefs.endpoints;
      url = ep.nextcloud.domain;
      user = "nextcloud";
      group = "nextcloud";
      mountUnit = "${utils.escapeSystemdPath config.services.nextcloud.home}.mount";
    in
    {
      nixdefs.endpoints.nextcloud = {
        domain = lib.mkForce "drive.js0ny.net";
      };
      sops.secrets.nextcloud_admin_pass = {
        sopsFile = secrets + /nextcloud.yaml;
      };

      services.nextcloud = {
        enable = true;
        package = pkgs.nextcloud34;
        hostName = url;
        autoUpdateApps.enable = true;
        https = true;
        caching.redis = true;
        configureRedis = true;
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

      nixdots.persist.system = {
        directories =
          let
            mode = "0750";
          in
          lib.unique [
            {
              inherit user group mode;
              directory = config.services.nextcloud.home;
            }
            {
              inherit user group mode;
              directory = config.services.nextcloud.datadir;
            }
            "/var/lib/redis-nextcloud"
          ];
      };

      systemd.services = lib.mkIf config.nixdots.persist.enable {
        # During a switch, tmpfiles and newly generated impermanence mounts may otherwise start concurrently.
        systemd-tmpfiles-resetup = {
          after = [ mountUnit ];
          requires = [ mountUnit ];
        };
        nextcloud-setup = {
          after = [
            mountUnit
            "systemd-tmpfiles-resetup.service"
          ];
          requires = [
            mountUnit
            "systemd-tmpfiles-resetup.service"
          ];
        };
      };
    };
}
