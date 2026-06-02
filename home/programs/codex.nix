{
  config,
  pkgs,
  ...
}:
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
}
