{
  pkgs,
  lib,
  osConfig,
  config,
  ...
}:
{
  imports = [
    ./codex
    ./pi-agent
    ./context
    ./ccusage.nix
    ./claude.nix
    ./oh-my-pi.nix
  ];
  home.packages = [
    pkgs.llm-agents.openspec
  ]
  ++ (lib.optionals osConfig.hardware.graphics.enable (
    with pkgs.llm-agents;
    [
      grok-bot
      dsh
    ]
  ));

  home.sessionVariables = {
    DSH_HOME = "${config.xdg.configHome}/deepseek-harness";
  };

  js0ny.persist.stores.state.directories = [
    ".config/magpie"
    ".config/deepseek-harness"
  ];
}
