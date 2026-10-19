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
      default = "gpt-5.6-luna-900k";
      provider = "openai-codex";
      base_url = "https://chatgpt.com/backend-api/codex";
      api_mode = "codex_responses";
    };

    image_gen = {
      provider = "openai-codex";
      model = "gpt-image-2-medium";
    };
    video_gen = {
      provider = "openrouter";
      model = "minimax/hailuo-3-max";
    };
  };
}
