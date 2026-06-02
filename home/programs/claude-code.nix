{
  config,
  pkgs,
  secrets,
  ...
}:
let
  models = config.nixdefs.llm.routing;
  model = models.code-plan.model;
in
{
  sops.secrets = {
    llm_key_claude_code = {
      sopsFile = secrets + /llm-integrations.yaml;
    };
  };
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
    package = pkgs.llm-agents.claude-code;
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
          },
          "statusline": {
              "type": "command",
              "command": "~/.config/claude/statusline.sh"
          }
      }
    '';
    path = "${config.xdg.configHome}/claude/settings.json";
  };
  xdg.configFile."claude/statusline.sh" = {
    text = /* bash */ ''
      #!/usr/bin/env bash
      # Statusline inspired by Starship prompt: os + dir + nix_shell, then prompt char
      dir=$(pwd | sed "s|$HOME|~|" | sed 's|/\(.\)[^/]*|/\1|g')
      nix_shell=""
      if [ -n "$IN_NIX_SHELL" ] || [ -n "$IN_PROTECTED_SHELL" ]; then
        nix_shell=" impure"
      elif [ -n "$name" ]; then
        nix_shell=" $name"
      fi
      # Check for nix develop / flake
      if grep -q nixcfgs <<< "$(pwd)" 2>/dev/null; then
        :
      fi

      printf '%s  %s' "$dir" "$nix_shell"
    '';
    executable = true;
  };
  makeMutable = [ ".config/claude/settings.json" ];

}
