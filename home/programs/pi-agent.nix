{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  system = pkgs.stdenv.system;
  pipkg-base = inputs.llm-agents.packages.${system}.pi;
  pipkg = pkgs.symlinkJoin {
    name = "pi-with-mcp";
    paths = [ pipkg-base ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram "$out/bin/pi" \
        --prefix PATH : ${
          lib.makeBinPath [
            pkgs.nodejs_26
            pkgs.uv
          ]
        }
    '';
  };
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
        "nixpkgs#nodejs_26"
        "--command"
        "npm"
      ];
      packages = [
        "npm:pi-provider-litellm"
        "npm:pi-mcp-adapter"
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
