{
  lib,
  config,
  pkgs,
  ...
}:
let
  ep = config.nixdefs.endpoints;
  llm = config.nixdefs.llm;
  models = llm.routing;
  ip = ep.open-webui.bindAddress;
  port = ep.open-webui.port;
  url = ep.open-webui.domain;
  selfhosted = config.nixdefs.selfhosted;
in
{
  nixdefs.selfhosted.open-webui = {
    enable = config.services.open-webui.enable;
  };
  services.open-webui = {
    host = ip;
    port = port;
    package = pkgs.open-webui.overrideAttrs (old: {
      propagatedBuildInputs =
        (old.propagatedBuildInputs or [ ]) ++ old.passthru.optional-dependencies.postgres;
    });
    environment = lib.mkMerge [
      {
        # 取消注释以暂时使用环境变量进行配置
        # 若取消设置，则部分设置会持久化
        # RESET_CONFIG_ON_START = "True";
        # ENABLE_PERSISTENT_CONFIG = "False";
        # General
        # env: WEBUI_SECRET_KEY
        ENV = "prod";
        ENABLE_VERSION_UPDATE_CHECK = "False";
        ENABLE_SIGNUP_PASSWORD_CONFIRMATION = "True";
        SCARF_NO_ANALYTICS = "True";
        ANONYMIZED_TELEMETRY = "False";
        DEFAULT_USER_ROLE = lib.mkDefault "pending";
        ENABLE_PUBLIC_ACTIVE_USERS_COUNT = "False";
        ENABLE_EVALUATION_ARENA_MODELS = "False";
        ENABLE_LOGIN_FORM = lib.mkDefault "True";
        ENABLE_SIGNUP = lib.mkDefault "False";

        # env: TAVILY_API_KEY
        WEB_SEARCH_ENGINE = "tavily";
        # env: OPENAI_API_KEY
        ENABLE_OPENAI_API = "True";
        # DATABASE_URL = "postgresql:///open-webui?host=/run/postgresql";
      }
      (lib.mkIf (url != null) {
        WEBUI_URL = lib.mkForce "https://${url}";
        CORS_ALLOW_ORIGIN = "https://${url}";
      })
      (lib.mkIf (selfhosted.openid.enable) {
        # env: OAUTH_CLIENT_SECRET
        OAUTH_MERGE_ACCOUNTS_BY_EMAIL = lib.mkDefault "True";
        ENABLE_OAUTH_PERSISTENT_CONFIG = lib.mkDefault "False";
        OAUTH_CLIENT_ID = "open-webui";
        OPENID_PROVIDER_URL = selfhosted.openid.discovery;
        OPENID_REDIRECT_URL = "https://${url}/oauth/oidc/callback";
        OAUTH_SCOPES = "openid email profile groups";
        OAUTH_PROVIDER_NAME = selfhosted.openid.name;
        ENABLE_OAUTH_SIGNUP = lib.mkDefault "True";
        # Note that authelia does not provide pictures, set it to empty.
        OAUTH_PICTURE_CLAIM = "";
        ENABLE_OAUTH_GROUP_MANAGEMENT = "True";
        ENABLE_OAUTH_GROUP_CREATION = "False";
        OAUTH_ROLES_CLAIM = "groups";
        ENABLE_OAUTH_ROLE_MANAGEMENT = "True";
        OAUTH_ADMIN_ROLES = "admin";
      })
      ### SearXNG
      (lib.mkIf (selfhosted.searxng.enable) {
        ENABLE_RAG_WEB_SEARCH = "True";
        RAG_WEB_SEARCH_ENGINE = "searxng";
        RAG_WEB_SEARCH_RESULT_COUNT = "3";
        RAG_WEB_SEARCH_CONCURRENT_REQUESTS = "10";
        SEARXNG_QUERY_URL = lib.mkDefault "${selfhosted.searxng.url}/search?q=<query>";
      })
      (lib.mkIf (llm.enable) {
        DEFAULT_MODEL = lib.mkDefault models.chat.model;
        TASK_MODEL = lib.mkDefault models.chat.model;
        TASK_MODEL_EXTERNAL = lib.mkDefault models.chat.model;
      })
    ];
  };

  services.nginx.virtualHosts =
    if url != null then
      {
        "${url}" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://localhost:${toString port}";
            proxyWebsockets = true;
            # proxy_http_version 1.1;
            extraConfig = ''
              proxy_buffering off;
              proxy_cache off;
              proxy_read_timeout 1800;
              proxy_send_timeout 1800;
              proxy_connect_timeout 1800;
              add_header X-Accel-Buffering "no" always;
            '';
          };
          extraConfig = ''
            add_header Alt-Svc 'h3=":443"; ma=86400';
          '';
        };
      }
    else
      { };

}
