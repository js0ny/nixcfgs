{
  flake.nixosModules.telegram-inline-llm-bot =
    { config, secrets, ... }:
    let
      ep = config.nixdefs.endpoints;
      models = config.nixdefs.llm.routing;
      sopsFile = secrets + /telegram-inline-llm-bot.yaml;
    in
    {
      sops.secrets = {
        tg_il_bot_litellm_api_key = { inherit sopsFile; };
        tg_il_bot_token = { inherit sopsFile; };
        tg_il_bot_allowedusers = { inherit sopsFile; };
      };
      sops.templates."tg-inline-llm-bot.env".content = /* bash */ ''
        API_KEY=${config.sops.placeholder.tg_il_bot_litellm_api_key}
        BOT_TOKEN=${config.sops.placeholder.tg_il_bot_token}
        ALLOWED_USER_IDS=${config.sops.placeholder.tg_il_bot_allowedusers}
      '';
      services.tg-inline-llm-bot = {
        enable = true;
        apiBase = "https://${ep.litellm.domain}/v1";
        model = "deepseek-v4-flash";
        collapseAnswer = true;
        collapseLineThreshold = -1;
        envFile = config.sops.templates."tg-inline-llm-bot.env".path;
      };
    };
}
