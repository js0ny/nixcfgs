{
  flake.nixosModules.librechat =
    {
      pkgs,
      lib,
      config,
      inputs,
      secrets,
      ...
    }:
    let
      configVersion = "1.3.9";
      ep = config.nixdefs.endpoints;
      epSelf = ep.librechat;
      url = epSelf.domain;
      portStr = epSelf.portStr;
      sec = config.sops.secrets;
      selfhosted = config.nixdefs.selfhosted;
      m = import ./librechat-helper.nix;
      sopsFile = secrets + /librechat.yaml;
    in
    {
      imports = [
        inputs.self.nixosModules.mongodb
        inputs.self.nixosModules.meilisearch
      ];
      sops.secrets = {
        librechat_creds_key = { inherit sopsFile; };
        librechat_creds_iv = { inherit sopsFile; };
        librechat_jwt_secret = { inherit sopsFile; };
        librechat_jwt_refresh_secret = { inherit sopsFile; };
        librechat_litellm_api_key = { inherit sopsFile; };
        meili_master_key = {
          sopsFile = secrets + /meilisearch.yaml;
        };
        context7_api_key = {
          sopsFile = secrets + /mcp.yaml;
        };
        librechat_oidc_secret = { inherit sopsFile; };
        librechat_openid_session_secret = { inherit sopsFile; };
        jina_api_key = {
          sopsFile = secrets + /llm.yaml;
        };
        firecrawl_api_key = {
          sopsFile = secrets + /mcp.yaml;
        };
        tavily_api_key = {
          sopsFile = secrets + /mcp.yaml;
        };
        openrouter_api_key = {
          sopsFile = secrets + /llm.yaml;
        };
      };
      services.librechat = {
        enable = true;
        # https://www.librechat.ai/docs/configuration/dotenv
        env = lib.mkMerge [
          {
            PORT = epSelf.port;
            HOST = epSelf.bindAddress;
            ALLOW_REGISTRATION = "false";
            MONGO_URI = lib.mkDefault "mongodb://127.0.0.1:${toString config.nixdefs.endpoints.mongodb.port}/LibreChat";
            ENDPOINTS = "LiteLLM,OpenRouter,openAI,anthropic,agents";
            ANTHROPIC_API_KEY = lib.mkDefault "user_provided";
            OPENAI_API_KEY = lib.mkDefault "user_provided";
            GOOGLE_KEY = lib.mkDefault "user_provided";
            ALLOW_SHARED_LINKS = lib.mkDefault "true";
            # Allows unauthenticated access to shared links. Defaults to false (auth required) if not set.
            ALLOW_SHARED_LINKS_PUBLIC = "true";
            SEARXNG_URL = selfhosted.searxng.url;
          }
          (lib.mkIf (url != null) {
            DOMAIN_CLIENT = epSelf.publicUrl;
            DOMAIN_SERVER = epSelf.publicUrl;
          })
          (lib.mkIf (selfhosted.openid.enable) {
            ALLOW_SOCIAL_LOGIN = "true";
            ALLOW_SOCIAL_REGISTRATION = "true";
            OPENID_BUTTON_LABEL = "Log in with Authelia";
            OPENID_ISSUER = ep.authelia.publicUrl;
            OPENID_CLIENT_ID = "librechat";
            OPENID_CALLBACK_URL = "/oauth/openid/callback";
            OPENID_SCOPE = "openid profile email";
            OPENID_ADMIN_ROLE = "admin";
            OPENID_ADMIN_ROLE_PARAMETER_PATH = "groups";
            OPENID_IMAGE_URL = "https://www.authelia.com/images/branding/logo-cropped.png";
            # Optional: redirects the user to the end session endpoint after logging out";
            OPENID_USE_END_SESSION_ENDPOINT = "true";
            OPENID_NAME_CLAIM = "preferred_username";
            OPENID_USERNAME_CLAIM = "preferred_username";
          })
        ];
        # like env = {} but passing file path
        # required:
        # CREDS_KEY
        # CREDS_IV
        # JWT_SECRET
        # JWT_REFRESH_SECRET
        credentials = {
          CREDS_KEY = sec.librechat_creds_key.path;
          CREDS_IV = sec.librechat_creds_iv.path;
          JWT_SECRET = sec.librechat_jwt_secret.path;
          JWT_REFRESH_SECRET = sec.librechat_jwt_refresh_secret.path;
          OPENROUTER_KEY = sec.openrouter_api_key.path;
          LITELLM_KEY = sec.librechat_litellm_api_key.path;
          CONTEXT7_API_KEY = sec.context7_api_key.path;
          OPENID_CLIENT_SECRET = sec.librechat_oidc_secret.path;
          OPENID_SESSION_SECRET = sec.librechat_openid_session_secret.path;
          JINA_API_KEY = sec.jina_api_key.path;
          FIRECRAWL_API_KEY = sec.firecrawl_api_key.path;
          TAVILY_API_KEY = sec.tavily_api_key.path;
        };
        # https://www.librechat.ai/docs/configuration/librechat_yaml
        settings = {
          modelSpecs = {
            enforce = false;
            prioritize = false;
            list = m;
          };
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
            mcpServers = {
              use = true;
              create = true;
              share = true;
              public = true;
            };
            temporaryChatRetention = 12; # hours
            modelSelect = true;
            parameters = true;
            presets = true;
            sidePanel = true;
            prompts = true;
            bookmarks = true;
            multiConvo = true;
          };
          mcpServers = config.nixdefs.mcp.clientConfigs.librechat or { };
          registration = {
            socialLogin = [ "openid" ];
          };
          memory = {
            disabled = false;
            validKeys = [
              "user_name"
              "user_preferences"
              "personal_information"
              "learned_facts"
              "context"
            ];
            agent = {
              provider = "LiteLLM";
              model = "MiniMax-M2.7";
              instructions = ''
                Store memory using only the specified validKeys. For user_preferences: save
                explicitly stated preferences about communication style, topics of interest,
                or workflow preferences. For conversation_context: save important facts or
                ongoing projects mentioned. For learned_facts: save objective information
                about the user. For personal_information: save only what the user explicitly
                shares about themselves. Delete outdated or incorrect information promptly.
              '';
            };
          };
          summarization = {
            provider = "LiteLLM";
            model = "deepseek-v4-flash"; # 1M
          };
          webSearch = {
            tavilyApiKey = "\${TAVILY_API_KEY}";
            searxngInstanceUrl = "\${SEARXNG_URL}";
            firecrawlApiKey = "\${FIRECRAWL_API_KEY}";
            jinaApiKey = "\${JINA_API_KEY}";
            safeSearch = 0;
            searchProvider = "tavily";
            scraperProvider = "firecrawl";
            rerankerType = "jina";
          };
          endpoints = {
            agents = { };
            custom = [
              {
                name = "OpenRouter";
                apiKey = "\${OPENROUTER_KEY}";
                baseURL = "https://openrouter.ai/api/v1";
                models = {
                  default = [ "deepseek/deepseek-v4-pro" ];
                  fetch = true;
                  titleConvo = true;
                  titleModel = "deepseek/deepseek-v4-flash";
                  dropParams = [ "stop" ];
                  modelDisplayLabel = "OpenRouter";
                };
              }
              {
                name = "LiteLLM";
                apiKey = "\${LITELLM_KEY}";
                baseURL = ep.litellm.publicUrl;
                iconURL = "https://github.com/lobehub/lobe-icons/blob/master/packages/static-webp/light/rsshub-color.webp?raw=true";
                models = {
                  default = [ "deepseek-v4-pro" ];
                  fetch = true;
                  titleConvo = true;
                  titleModel = "deepseek-v4-flash";
                  modelDisplayLabel = "LiteLLM";
                };
              }
            ];
          };
        };
        # enableLocalDB = true;
      };

      systemd.services.librechat = {
        path = lib.optionals (config.nixdefs.mcp.enable) [ pkgs.mcp-nixos ];
      };
      services.nginx.virtualHosts = lib.mkIf (url != null) {
        ${url} = {
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
        }
        // config.nixdefs.consts.nginxWithCF;
      };
      nixdots.persist.system.directories = [ config.services.librechat.dataDir ];
    };
}
