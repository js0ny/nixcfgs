{
  flake.nixosModules.affine =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      tag = "stable";

      ep = config.nixdefs.endpoints;
      epSelf = ep.affine;
      url = epSelf.domain or null;
      portStr = epSelf.portStr;
      inherit (lib) mkIf;
      dbname = "affine";
      dbuser = "affine";
      dbUrl = "postgresql://${dbuser}@localhost:5432/${dbname}";
      stateDir = "/var/lib/affine";
      storageDir = "${stateDir}/storage";
      configDir = "${stateDir}/config";
    in
    {

      # {{{ deps
      services.postgresql = {
        enable = true;
        extensions = ps: [ ps.pgvector ];
        ensureDatabases = [ dbname ];
        ensureUsers = [
          {
            name = dbuser;
            ensureDBOwnership = true;
            ensureClauses.login = true;
          }
        ];
      };

      services.redis.servers."affine" = {
        enable = true;
        port = ep.affine-redis.port;
        save = [ ];
        appendOnly = false;
      };
      # }}}

      # {{{ main
      virtualisation.oci-containers.containers.affine = {
        image = "ghcr.io/toeverything/affine:${tag}";
        extraOptions = [ "--network=host" ];
        environment = {
          AFFINE_SERVER_PORT = portStr;
          AFFINE_SERVER_HOST =
            if (url == null || config.services.nginx.enable != true) then "localhost" else url;
          REDIS_SERVER_HOST = "127.0.0.1";
          REDIS_SERVER_PORT = ep.affine-redis.portStr;
          AFFINE_INDEXER_ENABLED = "false";
          DATABASE_URL = dbUrl;
        };
        volumes = [
          "${storageDir}:/root/.affine/storage"
          "${configDir}:/root/.affine/config"
        ];
        log-driver = "journald";
      };

      systemd.services."podman-affine" = {
        after = [ "redis-affine.service" ];
        requires = [ "redis-affine.service" ];
        preStart = ''
          ${lib.getExe' pkgs.coreutils "mkdir"} -p ${storageDir} ${configDir}
          ${lib.getExe pkgs.podman} run --rm --network=host \
            -v ${storageDir}:/root/.affine/storage:rw \
            -v ${configDir}:/root/.affine/config:rw \
            --env DATABASE_URL=${dbUrl} \
            --env REDIS_SERVER_HOST=127.0.0.1 \
            --env REDIS_SERVER_PORT=${ep.affine-redis.portStr} \
            --env AFFINE_SERVER_PORT=${portStr} \
            ghcr.io/toeverything/affine:${tag} \
            node ./scripts/self-host-predeploy.js
        '';
      };
      # }}}

      # {{{ persistence
      nixdots.persist.system.directories = [
        stateDir
        "/var/lib/redis-affine"
      ];
      systemd.tmpfiles.rules = [
        "d ${storageDir} 0700 root root -"
        "d ${configDir} 0700 root root -"
      ];
      # }}}

      # {{{ nginx
      services.nginx.virtualHosts = lib.mkIf (url != null) {
        ${url} = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://localhost:${portStr}";
          };
        };
      };
      # }}}

    };
}
