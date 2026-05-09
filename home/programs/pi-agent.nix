{
  inputs,
  pkgs,
  config,
  ...
}:
let
  system = pkgs.stdenv.system;
  pipkg = inputs.llm-agents.packages.${system}.pi;
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
    "pi/agent/settings.json" = builtins.toJSON {
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
}
