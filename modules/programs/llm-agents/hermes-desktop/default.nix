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
        inputs.hermes-agent.homeManagerModules.default
        "${inputs.secrets}/llm-contexts/home/hermes.nix"
      ];

      programs.hermes-agent = {
        enable = true;
        desktop.enable = true;
      };
      services.hermes-agent = {
        package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.hermes-agent;
        hermesHome = "${config.xdg.configHome}/hermes-agent";
        backend.mode = "dashboard";
      };
      home.sessionVariables.AGENT_BROWSER_EXECUTABLE_PATH = lib.getExe pkgs.chromium;

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
