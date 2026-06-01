# TODO:
# * tiktoken
{
  config,
  pkgs,
  lib,
  ...
}:
let
  tag = "main-stable";

  ep = config.nixdefs.endpoints;
  epSelf = ep.litellm;
  url = epSelf.domain;
  portStr = epSelf.portStr;
  dbname = "litellm";
  dbuser = "litellm";
  settingsFormat = pkgs.formats.yaml { };
  litellmConfig = settingsFormat.generate "litellm-config.yaml" config.services.litellm.settings;
in
{
  imports = [
    ./search.nix
    ./mcp.nix
    ./llm.nix
    ./embedding.nix
    ./envs.nix
    ./rerank.nix
  ];
  services.litellm.settings = {
    litellm_settings = {
      drop_params = true;
    };
    general_settings = {
      master_key = "os.environ/LITELLM_MASTER_KEY";
      # Required for Claude Code
      forward_llm_provider_auth_headers = true;
    };
  };

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

  systemd.services.litellm-postgres-init = {
    description = "Initialize LiteLLM PostgreSQL role";
    requires = [ "postgresql-setup.service" ];
    after = [ "postgresql-setup.service" ];
    path = [ pkgs.postgresql ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "postgres";
      Group = "postgres";
      LoadCredential = "litellm_pw:${config.sops.secrets.litellm_db_password.path}";
    };
    script = ''
      set -euo pipefail
      PASSWORD=$(cat "$CREDENTIALS_DIRECTORY/litellm_pw")
      psql -v ON_ERROR_STOP=1 <<-EOF
        ALTER ROLE ${dbuser} WITH PASSWORD '$PASSWORD';
      EOF
    '';
  };

  virtualisation.oci-containers.containers.litellm = {
    image = "docker.litellm.ai/berriai/litellm:${tag}";
    extraOptions = [ "--network=host" ];
    volumes = [
      "${litellmConfig}:/app/config.yaml:ro"
    ];
    entrypoint = "/bin/sh";
    cmd = [
      "-c" # bash
      "rm /app/.npmrc && apk add --no-cache uv && exec litellm --config=/app/config.yaml --host=0.0.0.0 --port=${portStr}"
    ];
    log-driver = "journald";
  };

  systemd.services."podman-litellm" = {
    after = [ "litellm-postgres-init.service" ];
    requires = [ "litellm-postgres-init.service" ];
  };

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
/*
  curl -s https://openrouter.ai/api/v1/models | jq -r '
        ["MODEL", "PROMPT($/1M)", "COMPLETION($/1M)"],
        (.data[] | [
          .id,
          ((.pricing.prompt | tonumber) * 1000000),
          ((.pricing.completion | tonumber) * 1000000)
        ]) | @tsv
      ' | column -t | fzf --header-lines=1
*/
