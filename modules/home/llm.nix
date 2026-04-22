{ lib, config, ... }:
let
  llm = config.nixdefs.llm;
  enabledProviders = lib.filterAttrs (name: providerCfg: providerCfg.enable) llm.providers;
  queryProvider = provider: llm.providers."${provider}";
  npmSdkMap = {
    openai = "@ai-sdk/openai";
    openai-compat = "@ai-sdk/openai-compatible";
    anthropic = "@ai-sdk/anthropic";
    gemini = "@ai-sdk/google";
  };
  mapOpencodeModel =
    items:
    builtins.listToAttrs (
      map (item: {
        name = item;
        value = {
          name = item;
        };
      }) items
    );
  mapOpencodeProvider = builtins.mapAttrs (name: providerCfg: {
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
    models = mapOpencodeModel providerCfg.models;
  }) enabledProviders;
  aichatTypeMap = {
    "openai" = "openai-compatible";
    "openai-compat" = "openai-compatible";
    "anthropic" = "claude";
    "gemini" = "gemini";
  };
  mapAichatModel = models: map (model: { name = model; }) models;
  aichatClients = lib.mapAttrsToList (name: providerCfg: {
    name = name;
    type = aichatTypeMap.${providerCfg.apiType} or "openai-compatible";
    api_base = providerCfg.baseUrl;
    models = mapAichatModel providerCfg.models;
  }) enabledProviders;
in
lib.mkIf llm.enable {
  programs.aichat.settings = {
    model = "${llm.routing.chat.provider}:${llm.routing.chat.model}";
    clients = aichatClients;
  };

  programs.opencode.settings = {
    provider = mapOpencodeProvider;
    model = "${llm.routing.code-plan.provider}/${llm.routing.code-plan.model}";
  };

  programs.zed-editor.userSettings = {
    agent = {
      default_model = {
        provider = llm.routing.code-plan.provider;
        model = llm.routing.code-plan.model;
      };
    };
  };

  home.sessionVariables = {
    PDF2ZH_MODEL = llm.routing.translation.model;
    PDF2ZH_API_BASE = (queryProvider llm.routing.translation.provider).baseUrl;
  };
}
