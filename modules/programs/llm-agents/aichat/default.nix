{
  flake.homeModules.aichat =
    {
      lib,
      pkgs,
      config,
      secrets,
      ...
    }:
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
      configPath =
        if pkgs.stdenv.isDarwin then
          "${config.home.homeDirectory}/Library/Application Support/aichat/"
        else
          "${config.xdg.configHome}/aichat/";
    in
    {
      sops.secrets = {
        llm_key_aichat = {
          sopsFile = secrets + /llm-integrations.yaml;
        };
      };
      sops.templates."aichat.env" = {
        content = /* bash */ ''
          LITELLM_API_KEY=${config.sops.placeholder.llm_key_aichat}
        '';
        path = "${configPath}/.env";
        mode = "0400";
      };
      misc.shellAliases = {
        aic = "aichat -s";
      };
      programs.aichat = {
        enable = true;
        settings = {
          save_session = false;
          wrap = "auto";
          keybindings = "emacs";
          model = "${llm.routing.chat.provider}:${llm.routing.chat.model}";
          clients = aichatClients;
        };
      };
      systemd.user.tmpfiles.rules = [
        "d ${config.xdg.configHome}/aichat 0700 ${config.home.username} users -"
      ];
    };
}
