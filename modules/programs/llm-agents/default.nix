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
        ./codex/modules.nix
        ./pi-agent/modules.nix
        ./ccusage.nix
        ./oh-my-pi.nix
      ];
      home.packages = lib.optionals (osConfig.hardware.graphics.enable) [
        pkgs.llm-agents.dsh
        pkgs.js0ny.magpie
      ];

      home.sessionVariables = {
        DSH_HOME = "${config.xdg.configHome}/deepseek-harness";
      };

      js0ny.persist.stores.state.directories = [
        ".config/magpie"
        ".config/deepseek-harness"
      ];
    };

}
