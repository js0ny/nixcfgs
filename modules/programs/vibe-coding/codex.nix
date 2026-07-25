{
  config,
  pkgs,
  lib,
  ...
}:
let
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
  nixdots.persist.home.directories = [
    ".config/codex"
  ];

  home.sessionVariables = {
    CODEX_HOME = "${config.xdg.configHome}/codex";
  };
  programs.codex = {
    enable = true;
    package = pkgs.llm-agents.codex;
  };
  # https://learn.chatgpt.com/docs/config-file/config-basic
  xdg.configFile."codex/config.toml".source = pkgs.writers.writeTOML "codex-config.toml" {
    analytics.enabled = false;
    check_for_update_on_startup = false;
    default_permissions = ":workspace";
    model = "gpt-5.6-sol";
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
    };
  };
  home.packages = [ (lib.hiPrio codexWrapper) ];
}
