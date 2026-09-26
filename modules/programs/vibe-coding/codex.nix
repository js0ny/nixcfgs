{
  config,
  pkgs,
  lib,
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
  js0ny.persist.stores.state.directories = [ ".config/codex" ];

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
      model = "gpt-6-sol";
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
      # Hash calculation /* python3 */
      /*
        import hashlib
        import json

        identity = {
            "event_name": "session_start",
            "hooks": [{
                "async": False,
                "command": "bash '/home/js0ny/.config/codex/herdr-agent-state.sh' session",
                "timeout": 10,
                "type": "command",
            }],
        }

        payload = json.dumps(identity, sort_keys=True, separators=(",", ":"), ensure_ascii=False)
        print("sha256:" + hashlib.sha256(payload.encode("utf-8")).hexdigest())
      */
      hooks.state = {
        "${config.xdg.configHome}/codex/hooks.json:session_start:0:0" = {
          trusted_hash = "sha256:abcdb76f675d626b427d709a097643c97288c1ec6bf4dcbb3fb96bc7f874e8ba";
        };
      };
      desktop = {
        followUpQueueMode = "queue";
        localeOverride = "zh-CN";
        show-context-window-usage = true;
        notifications-turn-mode = "unfocused";
        appearanceLightCodeThemeId = "catppuccin";
        appearanceDarkCodeThemeId = "catppuccin";
        usePointerCursors = true;
        appearanceDiffMarkerStyle = "color";
        browser-show-full-url = true;
        keepRemoteControlAwakeWhilePluggedIn = false;
        open-in-target-preferences.global = "ghostty";
        # Catppuccin
        appearanceLightChromeTheme = {
          accent = "#8839ef";
          accentSource = "custom";
          contrast = 45;
          ink = "#4c4f69";
          opaqueWindows = false;
          surface = "#eff1f5";
          semanticColors = {
            diffAdded = "#40a02b";
            diffRemoved = "#d20f39";
            skill = "#8839ef";
          };
        };
        appearanceDarkChromeTheme = {
          accent = "#cba6f7";
          accentSource = "custom";
          contrast = 60;
          ink = "#cdd6f4";
          opaqueWindows = false;
          surface = "#1e1e2e";
          semanticColors = {
            diffAdded = "#a6e3a1";
            diffRemoved = "#f38ba8";
            skill = "#cba6f7";
          };
        };
      };
    };
  };
  home.packages = [ (lib.hiPrio codexWrapper) ];
  makeMutable = [ ".config/codex/config.toml" ];
}
