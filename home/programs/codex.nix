{
  config,
  inputs,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.system;
  codex = inputs.llm-agents.packages.${system}.codex;
in
{
  nixdots.persist.home = {
    directories = [
      ".config/codex"
    ];
  };
  home.sessionVariables = {
    CODEX_HOME = "${config.xdg.configHome}/codex";
  };
  programs.codex = {
    enable = true;
    package = pkgs.codex;
  };
}
