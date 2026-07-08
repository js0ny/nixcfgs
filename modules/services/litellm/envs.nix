{ config, secrets, ... }:
let
  sec = config.sops.placeholder;
  sopsFile = secrets + /litellm.yaml;
in
{
  sops.secrets = {
    openrouter_api_key = {
      sopsFile = secrets + /llm.yaml;
    };
    litellm_master_key = {
      inherit sopsFile;
      key = "master_key";
    };
    litellm_db_password = {
      inherit sopsFile;
      key = "db_password";
    };
    litellm_ui_password = {
      inherit sopsFile;
      key = "ui_password";
    };
    minimax_cn_api_key = {
      sopsFile = secrets + /llm.yaml;
    };
    deepseek_api_key = {
      sopsFile = secrets + /llm.yaml;
    };
    zai_cn_api_key = {
      sopsFile = secrets + /llm.yaml;
    };
    tavily_api_key = {
      sopsFile = secrets + /mcp.yaml;
    };
    firecrawl_api_key = {
      sopsFile = secrets + /mcp.yaml;
    };
    jina_api_key = {
      sopsFile = secrets + /llm.yaml;
    };
    context7_api_key = {
      sopsFile = secrets + /mcp.yaml;
    };
    aihubmix_api_key = {
      sopsFile = secrets + /llm.yaml;
    };
    sub2api_litellm_openai_api_key = {
      sopsFile = secrets + /litellm.yaml;
    };
    siliconflow_api_key = {
      sopsFile = secrets + /llm.yaml;
    };
  };

  sops.templates."litellm.env".content = /* bash */ ''
    OPENROUTER_API_KEY=${sec.openrouter_api_key}
    LITELLM_MASTER_KEY=${sec.litellm_master_key}
    DATABASE_URL=postgresql://litellm:${sec.litellm_db_password}@localhost:5432/litellm
    DEEPSEEK_API_KEY=${sec.deepseek_api_key}
    UI_PASSWORD=${sec.litellm_ui_password}
    MINIMAXCN_API_KEY=${sec.minimax_cn_api_key}
    ZAICN_API_KEY=${sec.zai_cn_api_key}
    TAVILY_API_KEY=${sec.tavily_api_key}
    FIRECRAWL_API_KEY=${sec.firecrawl_api_key}
    FIRECRAWL_MCP_URL=https://mcp.firecrawl.dev/${sec.firecrawl_api_key}/v2/mcp
    JINA_AI_API_KEY=${sec.jina_api_key}
    CONTEXT7_API_KEY=${sec.context7_api_key}
    AIHUBMIX_API_KEY=${sec.aihubmix_api_key}
    SUB2API_OPENAI_API_KEY=${sec.sub2api_litellm_openai_api_key}
    SILICONFLOW_API_KEY=${sec.siliconflow_api_key}
  '';

  virtualisation.oci-containers.containers.litellm = {
    environmentFiles = [ config.sops.templates."litellm.env".path ];
    environment = {
      # Extra API Base
      AIHUBMIX_API_BASE = "https://aihubmix.com/v1";
      YUNWU_API_BASE = "https://yunwu.ai/v1";
      MINIMAXCN_API_BASE = "https://api.minimaxi.com/anthropic";
      SILICONFLOW_API_BASE = "https://api.siliconflow.com/v1";

      # Config
      NO_DOCS = "True";
      NO_REDOC = "True";
      DISABLE_ADMIN_UI = "False";
      UI_USERNAME = "litellm";

      # MCP
      LITELLM_MCP_STDIO_EXTRA_COMMANDS = "mcp-nixos,nix";
    };
  };
}
