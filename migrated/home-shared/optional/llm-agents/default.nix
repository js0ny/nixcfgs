{ pkgs, ... }: {
  imports = [
    ./codex
    ./pi-agent
    ./context
  ];
  home.packages = with pkgs.llm-agents; [
    cursor-agent
    grok
    grok-bot
  ];
}
