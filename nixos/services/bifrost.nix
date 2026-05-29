# DEBUG: TRUE
{
  config,
  lib,
  pkgs,
  secrets,
  ...
}:
let
  stateDir = "/var/lib/bifrost";
  sec = config.sops.placeholder;
in
{
  sops.secrets = {
    openrouter_api_key = {
      sopsFile = secrets + /llm.yaml;
    };
    minimax_cn_api_key = {
      sopsFile = secrets + /llm.yaml;
    };
    deepseek_api_key = {
      sopsFile = secrets + /llm.yaml;
    };
    aihubmix_api_key = {
      sopsFile = secrets + /llm.yaml;
    };
    sub2api_litellm_openai_api_key = {
      sopsFile = secrets + /litellm.yaml;
    };
    jina_api_key = {
      sopsFile = secrets + /llm.yaml;
    };
    context7_api_key = {
      sopsFile = secrets + /mcp.yaml;
    };
  };
  sops.templates."bifrost.env".content = /* bash */ ''
    OPENROUTER_API_KEY=${sec.openrouter_api_key}
    DEEPSEEK_API_KEY=${sec.deepseek_api_key}
    MINIMAXCN_API_KEY=${sec.minimax_cn_api_key}
    AIHUBMIX_API_KEY=${sec.aihubmix_api_key}
    SUB2API_OPENAI_API_KEY=${sec.sub2api_litellm_openai_api_key}
    JINA_AI_API_KEY=${sec.jina_api_key}
    CONTEXT7_API_KEY=${sec.context7_api_key}
    OLLAMA_URL=http://127.0.0.1:${config.nixdefs.endpoints.ollama.portStr}
  '';

  services.bifrost = {
    settings = {
      "$schema" = "https://www.getbifrost.ai/schema";
      mcp = {
        client_configs = [
          {
            name = "nixos";
            connection_type = "stdio";
            is_ping_available = true;
            stdio_config = {
              command = lib.getExe pkgs.mcp-nixos;
            };
          }
          {
            name = "deepwiki";
            connection_type = "http";
            connection_string = "https://mcp.deepwiki.com/mcp";
          }
          {
            name = "gh_grep";
            connection_type = "http";
            connection_string = "https://mcp.grep.app";
          }
          {
            name = "context7";
            connection_type = "http";
            connection_string = "https://mcp.context7.com/mcp";
            headers = {
              "CONTEXT7_API_KEY" = "env.CONTEXT7_API_KEY";
            };
          }
        ];
      };
      providers = {
        openrouter = {
          keys = [
            {
              name = "OpenRouter Default Key";
              value = "env.OPENROUTER_API_KEY";
              models = [ "*" ];
              weight = 1.0;
            }
          ];
        };
      };
    };
    enable = true;
    package = pkgs.bifrost-http;
    openFirewall = false;
    port = 11112;
    logLevel = "info";
    stateDir = stateDir;
    environmentFile = config.sops.templates."bifrost.env".path;
    extraArgs = [
    ];
  };

  users.users.bifrost = {
    isSystemUser = true;
    group = "bifrost";
  };
  users.groups.bifrost = { };

  systemd.services.bifrost.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = "bifrost";
    Group = "bifrost";
    StateDirectory = lib.mkForce "";
  };

  systemd.tmpfiles.rules = [
    "d ${stateDir} 0750 bifrost bifrost -"
    "Z ${stateDir} 0750 bifrost bifrost -"
  ];

  nixdots.persist.system.directories = [ stateDir ];
}
