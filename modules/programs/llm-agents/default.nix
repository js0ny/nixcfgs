{
  flake.homeModules.llm-agents =
    {
      pkgs,
      lib,
      config,
      osConfig,
      ...
    }:
    {
      imports = [
        ./ccusage.nix
        ./oh-my-pi.nix
      ];
      home.packages = lib.optionals (osConfig.hardware.graphics.enable) [
        pkgs.llm-agents.dsh
        pkgs.js0ny.magpie
      ];

    };

}
