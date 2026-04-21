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
in
{
  options.nixdefs.llm = {
    enable = lib.mkEnableOption "LLM (Large Language Model)";
    providers = {
    };
    routing = lib.mkOption {
      type = lib.types.attrsOf modelRoutingType;
    };
  };

  config = lib.mkIf cfg.enable {
    nixdefs.llm = {
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
