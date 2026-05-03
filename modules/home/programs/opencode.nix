{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  system = pkgs.stdenv.system;
  ocpkg = inputs.llm-agents.packages.${system}.opencode;
  # Wrap bun to perform plugin installation
  ocbun = pkgs.symlinkJoin {
    name = "opencode-with-bun";
    paths = [ ocpkg ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram "$out/bin/opencode" \
        --prefix PATH : ${
          pkgs.lib.makeBinPath [
            pkgs.bun
            pkgs.git
            pkgs.cacert
          ]
        } \
        --set BUN_TELEMETRY_DISABLED 1 \
        --set CI 1
    '';
  };
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
        if providerCfg.apiKeyFile != null then
          "{file:${providerCfg.apiKeyFile}}"
        else if providerCfg.apiKeyEnv != null then
          "{env:${providerCfg.apiKeyEnv}}"
        else
          "";
    };
    models = mapOpenCodeModel providerCfg.models;
  }) enabledProviders;
in
lib.mkMerge [
  {
    programs.opencode = {
      package = ocbun;
      settings = {
        autoupdate = false;
      };
    };
  }
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
