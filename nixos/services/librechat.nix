{
  pkgs,
  lib,
  config,
  ...
}:
let
  configVersion = "1.3.9";
  ep = config.nixdefs.endpoints;
  epSelf = ep.librechat;
  url = epSelf.domain;
  portStr = epSelf.portStr;
in
{
  imports = [ ./mongodb.nix ];
  services.librechat = {
    # https://www.librechat.ai/docs/configuration/dotenv
    env = lib.mkMerge [
      {
        PORT = epSelf.port;
        HOST = epSelf.bindAddress;
        ALLOW_REGISTRATION = lib.mkDefault true;
        MONGO_URI = lib.mkDefault "mongodb://127.0.0.1:${toString config.nixdefs.endpoints.mongodb.port}/LibreChat";
        ENDPOINTS = lib.mkDefault "OpenRouter,openAI,anthropic";
        ANTHROPIC_API_KEY = lib.mkDefault "user_provided";
        OPENAI_API_KEY = lib.mkDefault "user_provided";
        GOOGLE_KEY = lib.mkDefault "user_provided";
        ALLOW_SHARED_LINKS = lib.mkDefault "true";
        # Allows unauthenticated access to shared links. Defaults to false (auth required) if not set.
        ALLOW_SHARED_LINKS_PUBLIC = lib.mkDefault "false";
      }
      (lib.mkIf (url != null) {
        DOMAIN_CLIENT = epSelf.publicUrl;
        DOMAIN_SERVER = epSelf.publicUrl;
      })
    ];
    # like env = {} but passing file path
    # required:
    # CREDS_KEY
    # CREDS_IV
    # JWT_SECRET
    # JWT_REFRESH_SECRET
    credentials = { };
    # https://www.librechat.ai/docs/configuration/librechat_yaml
    settings = {
      version = lib.mkDefault configVersion;
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
        marketplace.use = false;
        runCode = false;
      };
      mcpServers = config.nixdefs.mcp.clientConfigs.librechat or { };
    };
    # enableLocalDB = true;
  };

  systemd.services.librechat = {
    path = lib.optionals (config.nixdefs.mcp.enable) [ pkgs.mcp-nixos ];
  };
  services.nginx.virtualHosts = lib.mkIf (url != null) {
    "${url}" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:${portStr}";
        proxyWebsockets = true;
        # proxy_http_version 1.1;
        extraConfig = /* nginx */ ''
          proxy_buffering off;
          proxy_cache off;
          proxy_read_timeout 1800;
          proxy_send_timeout 1800;
          proxy_connect_timeout 1800;
          add_header X-Accel-Buffering "no" always;
        '';
      };
    };
  };
}
