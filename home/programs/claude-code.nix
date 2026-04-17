{
  config,
  inputs,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.system;
  ccpkg = inputs.llm-agents.packages.${system}.claude-code;
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
}
