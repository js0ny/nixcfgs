{
  flake.homeModules.hermes-desktop =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.llm-agents.hermes-desktop ];

      js0ny.persist.stores.state.directories = [ ".config/Hermes" ];

    };
}
