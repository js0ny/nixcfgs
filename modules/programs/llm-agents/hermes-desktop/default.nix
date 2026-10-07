{
  flake.homeModules.hermes-desktop =
    {
      pkgs,
      lib,
      config,
      inputs,
      ...
    }:
    {
      imports = [
        inputs.self.homeModules.hermes-agent
        "${inputs.secrets}/llm-contexts/home/hermes.nix"
      ];

      home.packages = with pkgs.llm-agents; [
        hermes-agent
        hermes-desktop
      ];
      home.sessionVariables = {
        AGENT_BROWSER_EXECUTABLE_PATH = (lib.getExe pkgs.chromium);
        HERMES_HOME = "${config.xdg.configHome}/hermes-agent";
      };

      js0ny.persist.stores.state.directories = [
        ".config/Hermes"
        ".config/hermes-agent"
      ];

      xdg.configFile = {
        "Hermes/project-dir.json".text = builtins.toJSON {
          dir = "${config.home.homeDirectory}/Atelier/hermes";
        };
      };
    };
}
