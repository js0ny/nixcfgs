{ config, secrets, ... }:
let
  sopsFile = secrets + "/pi-agent.yaml";
in
{
  sops.secrets = {
    pi_deepseek_api_key = { inherit sopsFile; };
    pi_openrouter_api_key = { inherit sopsFile; };
    pi_minimaxcn_api_key = { inherit sopsFile; };
    pi_openai_api_key = { inherit sopsFile; };
  };
  # https://pi.dev/docs/latest/models
  # https://pi.dev/docs/latest/models-configuration
  xdg.configFile."pi/agent/models.json".text = builtins.toJSON {
    "$schema" = "https://pi.dev/schemas/models.schema.json";
    providers = {
      deepseek.apiKey = "!cat ${config.sops.secrets.pi_deepseek_api_key.path}";
      openrouter.apiKey = "!cat ${config.sops.secrets.pi_openrouter_api_key.path}";
      minimax-cn.apiKey = "!cat ${config.sops.secrets.pi_minimaxcn_api_key.path}";
      openai.apiKey = "!cat ${config.sops.secrets.pi_openai_api_key.path}";
    };
  };
}
