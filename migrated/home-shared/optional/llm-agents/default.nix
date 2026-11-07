{
  pkgs,
  lib,
  osConfig,
  ...
}:
{
  imports = [
    ./codex
    ./pi-agent
    ./context
  ];
  home.packages = lib.optionals osConfig.hardware.graphics.enable (
    with pkgs.llm-agents; [ grok-bot ]
  );
}
