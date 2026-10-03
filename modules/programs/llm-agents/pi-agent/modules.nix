{
  pkgs,
  lib,
  config,
  ...
}:
let
  pibase = pkgs.llm-agents.pi;
  pi = pkgs.symlinkJoin {
    name = "pi-env";
    paths = [ pibase ];
    meta = pibase.meta // {
      mainProgram = "pi";
    };
    nativeBuildInputs = [ pkgs.makeWrapper ];
    /*nixfmt:disable*/
        postBuild = ''
          wrapProgram "$out/bin/pi" \
            --prefix PATH : ${ lib.makeBinPath [ pkgs.python3 pkgs.nodejs ] } \
            --set PI_CODING_AGENT_SESSION_DIR "${config.xdg.dataHome}/pi/agent/session" \
            --set PI_CODING_AGENT_DIR "${config.xdg.configHome}/pi/agent"
        '';
    /*nixfmt:enable*/
  };

in
{
  imports = [
    ./extensions/modules.nix
  ];
  home.packages = [ pi ];
  js0ny.persist.stores.state.directories = [ ".config/pi/agent" ];
  js0ny.persist.stores.local.directories = [ ".local/share/pi/agent" ];

  # https://pi.dev/docs/latest/environment-variables
  home.sessionVariables = {
    PI_SKIP_VERSION_CHECK = "1";
    PI_TELEMETRY = "0";
  };

  # https://pi.dev/docs/latest/settings
  xdg.configFile."pi/agent/settings.json".text = builtins.toJSON {
    enableInstallTelemetry = false;
    enableAnalytics = false;
    quietStartup = false;

    lastChangelogVersion = pibase.version;

    retry = {
      enabled = true;
      maxRetries = 3;
      baseDelayMs = 2000;
      provider = {
        timeoutMs = 3600 * 1000;
        maxRetries = 3;
        maxRetryDelayMs = 60 * 1000;
      };
    };

    npmCommand = [ (lib.getExe' pkgs.nodejs "npm") ];

    collapseChangelog = true;
    hideThinkingBlock = false;

    defaultProvider = "openai-codex";
    defaultModel = "gpt-6.1-sol";
    defaultThinkingLevel = "high";

    packages = [
      "npm:pi-subagents"
      "npm:pi-btw"
    ];

    enabledModels = [
      "openai-codex/gpt-6.1-sol"
      # keep-sorted start
      "deepseek/deepseek-v4-flash-vision-exp"
      "openai-codex/gpt-5.6-luna"
      "openai-codex/gpt-6-astra"
      # keep-sorted end
    ];
  };

}
