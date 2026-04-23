{ lib, config, ... }:
let
  llm = config.nixdefs.llm;
  enabledProviders = lib.filterAttrs (name: providerCfg: providerCfg.enable) llm.providers;
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
}
