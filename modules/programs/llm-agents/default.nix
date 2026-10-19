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
        ./pi-agent/modules.nix
        ./ccusage.nix
        ./herdr.nix
        ./oh-my-pi.nix
      ];
      home.packages = lib.optionals (osConfig.hardware.graphics.enable) [
        pkgs.llm-agents.dsh
        pkgs.js0ny.magpie-gui
      ];

      js0ny.persist.stores.state.directories = [ { directory = ".config/magpie"; } ];
    };

}
