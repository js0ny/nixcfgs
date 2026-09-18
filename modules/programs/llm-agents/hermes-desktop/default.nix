{
  flake.homeModules.hermes-desktop =
    {
      pkgs,
      config,
      inputs,
      ...
    }:
    {
      imports = [ inputs.self.homeModules.hermes-agent ];

      home.packages = with pkgs.llm-agents; [
        hermes-agent
        hermes-desktop
      ];

      home.sessionVariables.HERMES_HOME = "${config.xdg.configHome}/hermes-agent";

      js0ny.persist.stores.state.directories = [
        ".config/Hermes"
        ".config/hermes-agent"
      ];

    };
}
