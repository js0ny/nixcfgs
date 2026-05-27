{
  config,
  inputs,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.system;
  ccpkg = inputs.llm-agents.packages.${system}.claude-code;
  models = config.nixdefs.llm.routing;
  model = models.code-plan.model;
in
{
  nixdots.persist.home = {
    directories = [
      ".config/claude"
    ];
  };
  home.sessionVariables = {
    CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude";
  };
  programs.claude-code = {
    enable = true;
    package = ccpkg;
  };
  # Envs:
  # * CLAUDE_CODE_ATTRIBUTION_HEADER:
  #   用第三方模型遇到缓存命中率太低的问题一般需要把 cc 默认附加的 attribution header 禁用掉
  #   source: zhihu / docs.vllm.ai
  # * CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY:
  #   Discovery is opt-in. Without CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1, Claude Code will not query your proxy's /v1/models.
  #   source: https://docs.litellm.ai/docs/tutorials/claude_non_anthropic_models
  sops.templates."claude-settings.json" = {
    content = /* json */ ''
      {
          "env": {
              "ANTHROPIC_BASE_URL": "${config.nixdefs.endpoints.litellm.publicUrl}",
              "ANTHROPIC_AUTH_TOKEN": "${config.sops.placeholder.llm_key_claude_code}",
              "API_TIMEOUT_MS": "3000000",
              "CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY": 1,
              "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": 1,
              "CLAUDE_CODE_ATTRIBUTION_HEADER": 0,
              "ANTHROPIC_MODEL": "${model}",
              "ANTHROPIC_SMALL_FAST_MODEL": "${model}",
              "ANTHROPIC_DEFAULT_SONNET_MODEL": "${model}",
              "ANTHROPIC_DEFAULT_OPUS_MODEL": "${model}",
              "ANTHROPIC_DEFAULT_HAIKU_MODEL": "${model}"
          }
      }
    '';
    path = "${config.xdg.configHome}/claude/settings.json";
  };
}
