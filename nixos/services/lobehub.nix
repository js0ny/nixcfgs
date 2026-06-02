# NOTE: Human Intervention Required:
# * on first setup
# * Adding or deleting custom provider
# Using garage for s3 backend:
/*
  sudo garage bucket create lobe
  sudo garage bucket list
  sudo garage key create lobe-key # Remember to record the secrets
  sudo garage bucket allow lobe --read --write --owner --key lobe-key
*/
{
  config,
  pkgs,
  lib,
  secrets,
  ...
}:
let
  tag = "2.2.1";

  ep = config.nixdefs.endpoints;
  epSelf = ep.lobechat;
  url = epSelf.domain;
  portStr = epSelf.portStr;
  selfhosted = config.nixdefs.selfhosted;
  inherit (lib) mkDefault;
  dbname = "lobechat";
  sopsFile = secrets + /lobechat.yaml;
in
{
  sops.secrets = {
    lobechat_qstash_token = { inherit sopsFile; };
    lobechat_jwks_key = { inherit sopsFile; };
    lobechat_key_vaults = { inherit sopsFile; };
    lobechat_auth = { inherit sopsFile; };
    lobechat_db_password = { inherit sopsFile; };
    lobechat_s3_access_key = { inherit sopsFile; };
    lobechat_s3_secret_key = { inherit sopsFile; };
    lobechat_oidc_secret = { inherit sopsFile; };
    lobechat_litellm_api_key = { inherit sopsFile; };
  };

  services.postgresql = {
    enable = true;
    extensions = ps: [
      ps.pgvector
      ps.pg_search
    ];
    settings = {
      shared_preload_libraries = [ "pg_search" ];
    };
    ensureDatabases = [ dbname ];
    ensureUsers = [
      {
        name = "lobechat";
        ensureDBOwnership = true;
        ensureClauses.login = true;
      }
    ];
  };

  systemd.services.lobechat-postgres-init = {
    description = "Initialize LobeChat PostgreSQL role and extensions";
    requires = [ "postgresql-setup.service" ];
    after = [ "postgresql-setup.service" ];
    path = [ pkgs.postgresql ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "postgres";
      Group = "postgres";
      LoadCredential = "lobechat_pw:${config.sops.secrets.lobechat_db_password.path}";
    };
    script = ''
      set -euo pipefail

      PASSWORD=$(cat "$CREDENTIALS_DIRECTORY/lobechat_pw")

      psql -v ON_ERROR_STOP=1 <<-EOF
        ALTER ROLE lobechat WITH PASSWORD '$PASSWORD';

        \c lobechat

        CREATE EXTENSION IF NOT EXISTS vector;
        CREATE EXTENSION IF NOT EXISTS pg_search;
      EOF
    '';
  };

  systemd.services."podman-lobechat" = {
    after = [ "lobechat-postgres-init.service" ];
    requires = [ "lobechat-postgres-init.service" ];
  };

  virtualisation.oci-containers.containers.lobechat = {
    image = "lobehub/lobehub:${tag}";
    extraOptions = [ "--network=host" ];
    environmentFiles = [ config.sops.templates."lobechat.env".path ];
    environment = lib.mkMerge [
      {
        LOBE_PORT = portStr;
        APP_URL =
          if (url == null || config.services.nginx.enable != true) then
            "http://localhost:${portStr}"
          else
            epSelf.publicUrl;
        INTERNAL_APP_URL =
          if (url == null || config.services.nginx.enable != true) then
            "http://localhost:${portStr}"
          else
            epSelf.publicUrl;

        LOBE_DB_NAME = dbname;

        S3_ENDPOINT = mkDefault "http://localhost:${ep.garage-s3.portStr}";
        S3_REGION = mkDefault "garage";
        S3_BUCKET = "lobe";
        S3_ENABLE_PATH_STYLE = "1";
        S3_SET_ACL = mkDefault "0";

        LLM_VISION_IMAGE_USE_BASE64 = "1";

        REDIS_URL = "redis://127.0.0.1:${ep.lobechat-redis.portStr}";
        REDIS_PREFIX = "lobechat";
        REDIS_TLS = "0";

        FEATURE_FLAGS = "-check_updates";
        ENABLE_LANGFUSE = "0";

        API_KEY_SELECT_MODE = "turn";

        NEWAPI_PROXY_URL = config.nixdefs.consts.litellm.base;
        ENABLE_OIDC = "1";
      }
      (lib.mkIf (selfhosted.searxng.enable) {
        SEARXNG_URL = ep.searxng.publicUrl;
      })
      (lib.mkIf (selfhosted.openid.enable) {
        AUTH_SSO_PROVIDERS = lib.toLower selfhosted.openid.name;
        AUTH_AUTHELIA_ID = "lobechat";
        AUTH_AUTHELIA_ISSUER = ep.authelia.publicUrl;
        AUTH_DISABLE_EMAIL_PASSWORD = lib.mkForce "1";
      })
    ];
    log-driver = "journald";
  };

  sops.templates."lobechat.env".content = /* bash */ ''
    KEY_VAULTS_SECRET=${config.sops.placeholder.lobechat_key_vaults}
    AUTH_SECRET=${config.sops.placeholder.lobechat_auth}
    DATABASE_URL=postgresql://lobechat:${config.sops.placeholder.lobechat_db_password}@localhost:5432/lobechat
    S3_ACCESS_KEY=${config.sops.placeholder.lobechat_s3_access_key}
    S3_ACCESS_KEY_ID=${config.sops.placeholder.lobechat_s3_access_key}
    S3_SECRET_ACCESS_KEY=${config.sops.placeholder.lobechat_s3_secret_key}
    NEWAPI_API_KEY=${config.sops.placeholder.lobechat_litellm_api_key}
    AUTH_AUTHELIA_SECRET=${config.sops.placeholder.lobechat_oidc_secret}
    JWKS_KEY=${config.sops.placeholder.lobechat_jwks_key}
    QSTASH_TOKEN=${config.sops.placeholder.lobechat_qstash_token}
  '';

  services.redis.servers."lobechat" = {
    enable = true;
    port = ep.lobechat-redis.port;
    save = [ ];
    appendOnly = false;
  };

  services.garage.enable = true;

  services.nginx.virtualHosts = lib.mkIf (url != null) {
    ${url} = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:${portStr}";
      };
    };
  };
}
