{ lib, config, ... }:
let
  llm = config.nixdefs.llm;
  enabledProviders = lib.filterAttrs (name: providerCfg: providerCfg.enable) llm.providers;
  npmSdkMap = {
    openai = "@ai-sdk/openai";
    openai-compat = "@ai-sdk/openai-compatible";
    anthropic = "@ai-sdk/anthropic";
    gemini = "@ai-sdk/google";
  };
  mapOpenCodeModel =
    items:
    builtins.listToAttrs (
      map (item: {
        name = item;
        value = {
          name = item;
        };
      }) items
    );
  mappedOpenCodeProviders = builtins.mapAttrs (name: providerCfg: {
    npm = npmSdkMap.${providerCfg.apiType} or "@ai-sdk/openai-compatible";
    name = providerCfg.name;
    options = {
      baseURL = providerCfg.baseUrl;
      apiKey =
        if providerCfg.apiKeyEnv != null then
          "{env:${providerCfg.apiKeyEnv}}"
        else if providerCfg.apiKeyFile != null then
          "{file:${providerCfg.apiKeyFile}}"
        else
          "";
    };
    models = mapOpenCodeModel providerCfg.models;
  }) enabledProviders;
in
lib.mkMerge [
  (lib.mkIf config.nixdefs.acp.enable {
    nixdefs.acp.servers.opencode = {
      enable = config.programs.opencode.enable;
      command = "opencode";
      args = [ "acp" ];
    };
  })
  (lib.mkIf config.nixdefs.mcp.enable {
    programs.opencode.settings.mcp = config.nixdefs.mcp.servers;
  })
  (lib.mkIf config.nixdefs.llm.enable {
    programs.opencode.settings = {
      provider = mappedOpenCodeProviders;
      model = "${llm.routing.code-plan.provider}/${llm.routing.code-plan.model}";
    };
  })
]
