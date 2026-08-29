{ config, ... }:
let
  litellm = config.nixdefs.endpoints.litellm.publicUrl;
in
{
  services.hermes-agent.settings = {
    custom_providers = [
      {
        name = "litellm";
        base_url = "${litellm}/v1";
        key_env = "LITELLM_API_KEY";
      }
    ];

    model = {
      default = "gpt-5.6-terra";
      provider = "openai-codex";
    };

    auxiliary = {
      approval = {
        provider = "custom:litellm";
        model = "deepseek-v4-pro";
      };
      vision = {
        provider = "custom:litellm";
        model = "gemini-3.5-flash";
        download_timeout = 30;
      };
      compression = {
        provider = "custom:litellm";
        model = "deepseek-v4-pro";
      };
      mcp = {
        provider = "custom:litellm";
        model = "deepseek-v4-pro";
      };
      session_search = {
        provider = "custom:litellm";
        model = "deepseek-v4-flash";
      };
      web_extract = {
        provider = "custom:litellm";
        model = "deepseek-v4-flash";
      };
    };
  };
}
