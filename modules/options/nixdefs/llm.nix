{ lib, config, ... }:
let
  cfg = config.nixdefs.llm;
  modelRoutingType = lib.types.submodule {
    options = {
      provider = lib.mkOption {
        type = lib.types.str;
        default = "openrouter";
        example = "ollama";
        description = "LLM API Provider";
      };
      model = lib.mkOption {
        type = lib.types.str;
        default = "openrouter";
        example = "google/gemini-3-flash-preview";
        description = "Name of the model";
      };
    };
  };
  modelProviderType = lib.types.submodule (
    { name, ... }:
    {
      options = {
        enable = lib.mkEnableOption "Expose this provider";
        name = lib.mkOption {
          type = lib.types.str;
          default = name;
          example = "OpenRouter";
        };
        apiType = lib.mkOption {
          type = lib.types.enum [
            "openai"
            "anthropic"
            "gemini"
            "openai-compat"
          ];
          default = "openai";
          example = "anthropic";
          description = ''
            openai: /v1/responses
            openai-compat: /v1/chat/completions
          '';
        };
        baseUrl = lib.mkOption {
          type = lib.types.str;
          example = "https://openrouter.ai/v1";
        };
        apiKeyFile = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = ''''${config.sops.secrets."openrouter_api_key".path}'';
          description = "Absolute path to the file containing the API key.";
        };
        apiKeyEnv = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "OPENROUTER_API_KEY";
          description = "Name of the environment variable containing the API key.";
        };
        # TODO: Support attrs for further information, see also: modules/home/llm.nix
        models = lib.mkOption {
          type = with lib.types; listOf (either str attrs);
          default = [ ];
          example = [
            "gemini-3-flash-preview"
          ];
        };
      };
    }
  );
in
{
  options.nixdefs.llm = {
    enable = lib.mkEnableOption "LLM (Large Language Model)";
    providers = lib.mkOption {
      type = lib.types.attrsOf modelProviderType;
    };
    routing = lib.mkOption {
      type = lib.types.attrsOf modelRoutingType;
    };
  };

  config = lib.mkIf cfg.enable {
    nixdefs.llm = {
      providers = {
        openrouter = {
          baseUrl = "https://openrouter.ai/v1";
          apiType = "openai";
        };
        minimax-cn = {
          baseUrl = "https://api.minimaxi.com/anthropic";
          apiType = "anthropic";
        };
        minimax-cn-openai = {
          baseUrl = "https://api.minimaxi.com/v1";
          apiType = "openai";
        };
      };
      routing = {
        translation = {
          provider = "openrouter";
          model = "google/gemini-3-flash-preview";
        };
        chat = {
          provider = "openrouter";
          model = "google/gemini-3-flash-preview";
        };
        code-plan = {
          provider = "openrouter";
          model = "openai/gpt-5.4";
        };
        code-build = {
          provider = "openrouter";
          model = "openai/gpt-5.4";
        };
        agent = {
          provider = "openrouter";
          model = "minimax/minimax-m2.7";
        };
      };
    };
  };
}
