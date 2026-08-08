{
  config,
  pkgs,
  lib,
  ...
}:
let
  shell = config.nixdots.apps.interactiveShell.package;
  cfg = config.programs.herdr;
in
{
  programs.herdr = {
    enable = true;
    package = pkgs.llm-agents.herdr;
    # https://herdr.dev/docs/config-reference/
    settings = {
      onboarding = false;
      terminal = {
        default_shell = lib.getExe shell;
        new_cwd = "follow";
      };
      update = {
        channel = "stable";
        version_check = false;
        manifest_check = true;
      };
      experimental = {
        kitty_graphics = (config.programs.kitty.enable || config.programs.ghostty.enable);
      };
      keys = {
        prefix = "ctrl+b";
        help = "prefix+?";
        switch_tab = [
          "prefix+1..9"
          "alt+1..9"
        ];
      };
      ui = {
        tab_bar_position = "bottom";
        toast = {
          delivery = "terminal";
          herdr.position = "bottom-right";
        };
        sidebar_start_collapsed = true;
        prompt_new_tab_name = false;
        prompt_new_workspace_name = false;
      };
      worktrees.directory = "${config.xdg.stateHome}/herdr/worktrees";
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
    "codex/herdr-agent-state.sh".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/herdrdev/herdr/refs/tags/v${config.programs.herdr.package.version}/src/integration/assets/codex/herdr-agent-state.sh";
      hash = "sha256-KsgRU1n/hJzWHkUFdLNx9nMngKY6B62HwARI21wgNi0=";
    };
    "herdr/config.toml".onChange =
      let
        binPath = if cfg.package == null then "herdr" else "${lib.getExe cfg.package}";
      in
      lib.mkForce /* bash */ ''
        ${binPath} config check
        ${binPath} server reload-config || true
      '';
  };
}
