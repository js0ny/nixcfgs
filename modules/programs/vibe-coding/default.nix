{
  flake.homeModules.vibe-coding =
    {
      inputs,
      pkgs,
      lib,
      osConfig,
      ...
    }:
    {
      imports = [
        ./claude-code.nix
        ./codex.nix
        ./pi-agent.nix
        ./herdr.nix
        ./oh-my-pi.nix
        inputs.self.homeModules.opencode
      ];
      home.packages =
        with pkgs;
        [
          llm-agents.agentsview
          llm-agents.ccusage
          abtop
        ]
        ++ lib.optionals (osConfig.hardware.graphics.enable) [
          llm-agents.chatgpt
          llm-agents.dsh
        ];
    };
}
