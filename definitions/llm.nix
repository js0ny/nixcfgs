{ lib, config, ... }:
let
  ep = config.nixdefs.endpoints;
  litellm-models = import ../modules/services/litellm/litellm-models.nix;
  litellm-flat = map (i: i.model_name) litellm-models;
in
{
  nixdefs.llm = {
    providers = {
      litellm = {
        enable = true;
        name = "LiteLLM";
        apiType = "openai-compat";
        baseUrl = "${ep.litellm.publicUrl}/v1";
        models = litellm-flat;
      };
    };
    routing = lib.mkForce {
      translation = {
        provider = "litellm";
        model = "deepseek-v4-flash";
      };
      chat = {
        provider = "litellm";
        model = "deepseek-v4-flash";
      };
      code-plan = {
        provider = "litellm";
        model = "deepseek-v4-pro";
      };
      code-build = {
        provider = "litellm";
        model = "deepseek-v4-pro";
      };
      agent = {
        provider = "litellm";
        model = "deepseek-v4-flash";
      };
      vision = {
        provider = "litellm";
        model = "gemini-3.5-flash";
      };
    };
  };
}
