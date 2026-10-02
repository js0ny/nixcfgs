{
  flake.homeModules.llm-agents =
    {
      pkgs,
      lib,
      osConfig,
      ...
    }:
    {
      imports = [
        ./codex/modules.nix
        ./mcp/modules.nix
        ./pi-agent/modules.nix
        ./ccusage.nix
        ./herdr.nix
        ./oh-my-pi.nix
      ];
      home.packages = lib.optionals (osConfig.hardware.graphics.enable) [
        pkgs.llm-agents.dsh
      ];
    };

}
