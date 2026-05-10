{
  inputs,
  pkgs,
  config,
  ...
}:
let
  system = pkgs.stdenv.system;
  pipkg = inputs.llm-agents.packages.${system}.pi;
  llm = config.nixdefs.llm;
  models = llm.routing;
in
{
  home.packages = [ pipkg ];
  home.sessionVariables = {
    PI_CODING_AGENT_DIR = "${config.xdg.configHome}/pi/agent";
    PI_TELEMETRY = "0";
    PI_SKIP_VERSION_CHECK = "1";
    PI_OFFLINE = "1";
  };
  xdg.configFile = {
    "pi/agent/settings.json".text = builtins.toJSON {
      lastChangelogVersion = "0.72.1";
      defaultProvider = models.code-build.provider;
      defaultModel = models.code-build.model;
      defaultThinkingLevel = "high";
      npmCommand = [
        "nix"
        "shell"
        "nixpkgs#nodejs_24"
        "--command"
        "npm"
      ];
      packages = [
        "npm:pi-provider-litellm"
      ];
    };
  };
  nixdots.persist.home = {
    directories = [
      ".config/pi"
    ];
  };

  makeMutable = [
    ".config/pi/agent/settings.json"
  ];
}
