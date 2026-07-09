{
  pkgs,
  lib,
  config,
  ...
}:
let
  ep = config.nixdefs.endpoints;
  ocpkg = pkgs.llm-agents.opencode;
  # Wrap bun to perform plugin installation
  ocbun = pkgs.symlinkJoin {
    name = "opencode-with-bun";
    paths = [ ocpkg ];
    meta = ocpkg.meta // {
      mainProgram = "opencode";
    };
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram "$out/bin/opencode" \
        --prefix PATH : ${lib.makeBinPath [ pkgs.bun ]} \
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
{
  programs.opencode = {
    package = ocbun;
    settings = {
      autoupdate = false;
      server = {
        port = ep.opencode.port;
        hostname = ep.opencode.bindAddress;
      };
      mcp = config.nixdefs.mcp.clientConfigs.opencode;
      provider = mappedOpenCodeProviders // {
        litellm.options.apiKey = "{file:${config.sops.secrets.llm_key_opencode.path}}";
      };
    };
    tui = {
      keybinds = {
        "command_list" = lib.concatStringsSep "," [
          "alt+x"
          "ctrl+p"
          "<leader>;"
        ];
        "editor_open" = lib.concatStringsSep "," [
          "alt+e"
          "<leader>e"
        ];
        "prompt.autocomplete.select" = lib.concatStringsSep "," [
          "return"
          "ctrl+y"
        ];
      };
    };
  };
  nixdefs.acp.servers.opencode = {
    enable = config.programs.opencode.enable;
    command = "opencode";
    args = [ "acp" ];
  };
}
