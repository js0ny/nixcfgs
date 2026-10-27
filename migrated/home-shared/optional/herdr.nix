{
  config,
  pkgs,
  lib,
  ...
}:
let
  shell = config.js0ny.apps.interactiveShell.package;
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
        kitty_graphics = true;
        new_cwd = "follow";
      };
      update = {
        channel = "stable";
        version_check = false;
        manifest_check = true;
      };

      remote.manage_ssh_config = false;

      keys = {
        prefix = "ctrl+m";
        help = "prefix+?";
        switch_tab = [
          "prefix+1..9"
          "alt+1..9"
        ];
        goto = [
          "prefix+g"
          "alt+shift+o" # zellij
          "prefix+shift+o"
        ];
        detach = "prefix+d";
        close_workspace = "prefix+shift+q";
        reload_config = [ ];
      };
      ui = {
        tab_bar_position = "bottom";
        toast = {
          delivery = "system";
          herdr.position = "bottom-right";
        };
        sidebar_start_collapsed = true;
        prompt_new_tab_name = false;
        prompt_new_workspace_name = false;
      };
      worktrees.directory = "${config.xdg.stateHome}/herdr/worktrees";
    };
  };

  xdg.configFile."herdr/config.toml".onChange =
    let
      binPath = if cfg.package == null then "herdr" else "${lib.getExe cfg.package}";
    in
    lib.mkForce /* bash */ ''
      ${binPath} config check
      ${binPath} server reload-config || true
    '';
}
