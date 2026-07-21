{
  flake.homeModules.vibe-coding =
    { inputs, pkgs, ... }:
    {
      imports = [
        # ./claude-code.nix
        ./codex.nix
        ./pi-agent.nix
        # ./oh-my-pi.nix
        inputs.self.homeModules.opencode
      ];
      home.packages = with pkgs; [
        llm-agents.agentsview
        llm-agents.ccusage
        herdr
        abtop
      ];
    };
}
