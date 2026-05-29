let
  env = key: "os.environ/${key}";

  providerMap = {
    deepseek = {
      provider = "deepseek";
      litellm_params.api_key = env "DEEPSEEK_API_KEY";
    };

    openrouter = {
      provider = "openrouter";
      litellm_params.api_key = env "OPENROUTER_API_KEY";
    };

    minimax-cn = {
      provider = "anthropic";
      litellm_params = {
        api_key = env "MINIMAXCN_API_KEY";
        api_base = "https://api.minimaxi.com/anthropic";
      };
    };

    aihubmix = {
      provider = "openai";
      litellm_params = {
        api_key = env "AIHUBMIX_API_KEY";
        api_base = "https://aihubmix.com";
      };
    };

    sub2api-openai = {
      provider = "openai";
      litellm_params = {
        api_key = env "SUB2API_OPENAI_API_KEY";
        api_base = "http://127.0.0.1:11070/v1";
      };
    };
  };

  mkLiteLLMModels =
    model:
    map (
      upstream:
      let
        providerAttrs = builtins.getAttr upstream.provider providerMap;
        orderAttrs = if upstream ? order then { order = upstream.order; } else { };
      in
      {
        model_name = model.id;

        litellm_params = {
          model = "${providerAttrs.provider}/${upstream.model}";
        }
        // providerAttrs.litellm_params
        // orderAttrs;

        model_info = {
          max_input_tokens = model.limit.context;
          max_output_tokens = model.limit.output;
          mode = model.kind;
          supports_function_calling = model.capabilities.tools;
          input_cost_per_token = model.pricing.input;
          output_cost_per_token = model.pricing.output;
          cache_read_input_token_cost = model.pricing.cacheRead;
        };
      }
    ) model.upstream;

  mkLiteLLMModelList =
    models:
    builtins.concatLists (
      builtins.attrValues (builtins.mapAttrs (_name: model: mkLiteLLMModels model) models)
    );
in
{
  inherit mkLiteLLMModels mkLiteLLMModelList;
}
