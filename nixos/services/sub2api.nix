{
  config,
  pkgs,
  lib,
  secrets,
  ...
}:
let
  tag = "latest";

  ep = config.nixdefs.endpoints;
  url = ep.sub2api.domain or null;
  portStr = ep.sub2api.portStr;
  redisPort = toString ep.sub2api-redis.port;
  inherit (lib) mkIf optionalAttrs;
  dbname = "sub2api";
  dbuser = "sub2api";
  stateDir = "/var/lib/sub2api";
  sopsFile = secrets + /sub2api.yaml;
in
{

  # {{{ secrets
  sops.secrets = {
    sub2api_admin_password = { inherit sopsFile; };
    sub2api_db_password = { inherit sopsFile; };
    sub2api_jwt_secret = { inherit sopsFile; };
    sub2api_totp_encryption_key = { inherit sopsFile; };
  };
  # }}}

  # {{{ deps
  services.postgresql = {
    enable = true;
    ensureDatabases = [ dbname ];
    ensureUsers = [
      {
        name = dbuser;
        ensureDBOwnership = true;
        ensureClauses.login = true;
      }
    ];
  };

  systemd.services.sub2api-postgres-init = {
    description = "Initialize Sub2API PostgreSQL role";
    requires = [ "postgresql-setup.service" ];
    after = [ "postgresql-setup.service" ];
    path = [ pkgs.postgresql ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "postgres";
      Group = "postgres";
      LoadCredential = "sub2api_pw:${config.sops.secrets.sub2api_db_password.path}";
    };
    script = ''
      set -euo pipefail

      PASSWORD=$(cat "$CREDENTIALS_DIRECTORY/sub2api_pw")

      psql -v ON_ERROR_STOP=1 -v "sub2api_password=$PASSWORD" <<-EOF
        ALTER ROLE ${dbuser} WITH PASSWORD :'sub2api_password';
      EOF
    '';
  };

  services.redis.servers."sub2api" = {
    enable = true;
    port = ep.sub2api-redis.port;
    save = [
      [
        60
        1
      ]
    ];
    appendOnly = true;
  };

  systemd.services."podman-sub2api" = {
    after = [
      "sub2api-postgres-init.service"
      "redis-sub2api.service"
    ];
    requires = [
      "sub2api-postgres-init.service"
      "redis-sub2api.service"
    ];
    serviceConfig.TimeoutStartSec = lib.mkForce "10min";
  };
  # }}}

  # {{{ main
  virtualisation.oci-containers.containers.sub2api = {
    image = "weishaw/sub2api:${tag}";
    extraOptions = [
      "--network=host"
      "--no-healthcheck"
      "--ulimit=nofile=100000:100000"
    ];
    environmentFiles = [ config.sops.templates."sub2api.env".path ];
    environment = {
      AUTO_SETUP = "true";
      SERVER_HOST = "0.0.0.0";
      SERVER_PORT = portStr;
      SERVER_MODE = "release";
      RUN_MODE = "standard";
      TZ = "Etc/UTC";

      DATABASE_HOST = "127.0.0.1";
      DATABASE_PORT = "5432";
      DATABASE_USER = dbuser;
      DATABASE_DBNAME = dbname;
      DATABASE_SSLMODE = "disable";
      DATABASE_MAX_OPEN_CONNS = "256";
      DATABASE_MAX_IDLE_CONNS = "128";
      DATABASE_CONN_MAX_LIFETIME_MINUTES = "30";
      DATABASE_CONN_MAX_IDLE_TIME_MINUTES = "5";

      REDIS_HOST = "127.0.0.1";
      REDIS_PORT = redisPort;
      REDIS_DB = "0";
      REDIS_POOL_SIZE = "4096";
      REDIS_MIN_IDLE_CONNS = "256";
      REDIS_ENABLE_TLS = "false";

      ADMIN_EMAIL = "admin@sub2api.local";
      JWT_EXPIRE_HOUR = "24";
      JWT_ACCESS_TOKEN_EXPIRE_MINUTES = "0";

      LOG_LEVEL = "info";
      LOG_FORMAT = "json";
      LOG_OUTPUT_TO_STDOUT = "true";
      LOG_OUTPUT_TO_FILE = "true";
    };
    volumes = [
      "${stateDir}:/app/data"
    ];
    log-driver = "journald";
  };

  sops.templates."sub2api.env".content = /* bash */ ''
    DATABASE_PASSWORD=${config.sops.placeholder.sub2api_db_password}
    ADMIN_PASSWORD=${config.sops.placeholder.sub2api_admin_password}
    JWT_SECRET=${config.sops.placeholder.sub2api_jwt_secret}
    TOTP_ENCRYPTION_KEY=${config.sops.placeholder.sub2api_totp_encryption_key}
  '';
  # }}}

  # {{{ tmpfiles
  systemd.tmpfiles.rules = [
    "d ${stateDir} 0700 root root -"
  ];
  # }}}

  # {{{ persistence
  nixdots.persist.system.directories = [
    stateDir
    "/var/lib/redis-sub2api"
  ];
  # }}}

  # {{{ nginx
  services.nginx.virtualHosts = optionalAttrs (url != null) {
    "${url}" = mkIf (url != null) {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:${portStr}";
      };
    };
  };
  # }}}
}
