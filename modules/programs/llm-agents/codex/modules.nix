{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  # path = lib.makeBinPath [
  #   pkgs.nodejs_26
  #   (pkgs.python314.withPackages (p: [ p.pyyaml ]))
  #   pkgs.uv
  # ];
  # https://github.com/openai/codex/issues/14599#issuecomment-4098754431
  codexWrapper = pkgs.writers.writePython3Bin "codex" { } /* python */ ''
    import json
    import os
    import sys
    from pathlib import Path


    CODEX = "${lib.getExe config.programs.codex.package}"


    def main() -> None:
        project = json.dumps(str(Path.cwd()))
        config = f'projects={{{project}={{trust_level="trusted"}}}}'
        os.execvp(CODEX, [CODEX, "-c", config, *sys.argv[1:]])


    if __name__ == "__main__":
        main()
  '';
in
{
  imports = [ ./desktop.nix ];
  js0ny.persist.stores = {
    state.directories = [ ".config/codex" ];
    local.directories = [ ".cache/codex-runtimes" ];
  };

  home.sessionVariables = {
    CODEX_HOME = "${config.xdg.configHome}/codex";
  };
  programs.codex = {
    enable = true;
    package = pkgs.llm-agents.codex;
    # https://learn.chatgpt.com/docs/config-file/config-basic
    settings = {
      analytics.enabled = false;
      check_for_update_on_startup = false;
      default_permissions = ":workspace";
      sandbox_mode = "danger-full-access";
      model = "gpt-6.1-sol";
      model_reasoning_effort = "medium";
      features.hooks = true;
      tui = {
        status_line = [
          "model-with-reasoning"
          "current-dir"
          "git-branch"
          "permissions"
          "approval-mode"
          "context-remaining"
          "five-hour-limit"
          "weekly-limit"
        ];
        status_line_use_colors = true;
        vim_mode_default = true;
      };
      hooks.state = lib.mkIf config.programs.herdr.enable {
        "${config.xdg.configHome}/codex/hooks.json:session_start:0:0" = {
          trusted_hash = "sha256:abcdb76f675d626b427d709a097643c97288c1ec6bf4dcbb3fb96bc7f874e8ba";
        };
      };
      mcp_servers = config.js0ny.mcp.clientSettings.codex.mcp_servers;
    };
  };

  programs.codex.hooks = {
    SessionStart = [
      {
        hooks = [
          {
            type = "command";
            command = "bash '${config.xdg.configHome}/codex/herdr-agent-state.sh' session";
            timeout = 10;
          }
        ];
      }
    ];
  };
  xdg.configFile = {
    "codex/herdr-agent-state.sh".source =
      "${config.programs.herdr.package.src}/src/integration/assets/codex/herdr-agent-state.sh";
  };
  home.packages = [
    (lib.hiPrio codexWrapper)
  ]
  ++ lib.optionals (osConfig.hardware.graphics.enable) [ pkgs.llm-agents.chatgpt ];
  makeMutable = [ ".config/codex/config.toml" ];
}
