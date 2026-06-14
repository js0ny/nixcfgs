{
  pkgs,
  lib,
  config,
  secrets,
  ...
}:
let
  pipkg = pkgs.symlinkJoin {
    name = "pi-with-mcp";
    paths = [ pkgs.llm-agents.pi ];
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
  sops.secrets = {
    llm_key_pidev = {
      sopsFile = secrets + /llm-integrations.yaml;
    };
  };
  home.packages = [ pipkg ];
  home.sessionVariables = {
    PI_CODING_AGENT_DIR = "${config.xdg.configHome}/pi/agent";
    PI_TELEMETRY = "0";
    PI_SKIP_VERSION_CHECK = "1";
    PI_OFFLINE = "1";
  };
  xdg.configFile = {
    "pi/agent/settings.json".text = builtins.toJSON {
      lastChangelogVersion = "0.78.1";
      defaultProvider = models.code-build.provider;
      defaultModel = models.code-build.model;
      defaultThinkingLevel = "high";
      collapseChangelog = true;
      enableInstallTelemetry = false;
      enableAnalytics = false;
      sessionDir = "${config.xdg.dataHome}/pi/agent/sessions";
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
        "npm:pi-direnv"
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
