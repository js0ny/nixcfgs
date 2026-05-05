{
  pkgs,
  lib,
  config,
  ...
}:
let
  ep = config.nixdefs.endpoints.librechat;
  url = ep.domain;
  port = ep.port;
in
{
  services.librechat = {
    # https://www.librechat.ai/docs/configuration/dotenv
    env = {
      PORT = ep.port;
      HOST = ep.bindAddress;
      ALLOW_REGISTRATION = lib.mkDefault true;
      MONGO_URI = lib.mkDefault "mongodb://127.0.0.1:${toString config.nixdefs.endpoints.mongodb.port}/LibreChat";
      ENDPOINTS = lib.mkDefault "OpenRouter,openAI,anthropic";
      ANTHROPIC_API_KEY = lib.mkDefault "user_provided";
      OPENAI_API_KEY = lib.mkDefault "user_provided";
      GOOGLE_KEY = lib.mkDefault "user_provided";
      ALLOW_SHARED_LINKS = lib.mkDefault "true";
      # Allows unauthenticated access to shared links. Defaults to false (auth required) if not set.
      ALLOW_SHARED_LINKS_PUBLIC = lib.mkDefault "false";
    };
    # like env = {} but passing file path
    # required:
    # CREDS_KEY
    # CREDS_IV
    # JWT_SECRET
    # JWT_REFRESH_SECRET
    credentials = { };
    # https://www.librechat.ai/docs/configuration/librechat_yaml
    settings = {
      version = lib.mkDefault "1.3.9";
      cache = true;

      interface = {
        privacyPolicy = lib.mkDefault {
          externalUrl = "https://librechat.ai/privacy-policy";
          openNewTab = true;
        };
        termsOfService = lib.mkDefault {
          externalUrl = "https://librechat.ai/tos";
          openNewTab = true;
        };
      };
      mcpServers = config.nixdefs.mcp.clientConfigs.librechat or { };
    };
    # enableLocalDB = true;
  };

  systemd.services.librechat = {
    path = lib.optionals (config.nixdefs.mcp.enable) [ pkgs.mcp-nixos ];
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
