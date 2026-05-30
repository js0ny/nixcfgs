{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  models = config.nixdefs.llm.routing;
  consts = config.nixdefs.consts;
  litellm = config.nixdefs.endpoints.litellm.publicUrl;
in
{
  environment.variables = {
    HERMES_HOME = "/var/lib/hermes/.hermes";
  };
  imports = [
    inputs.hermes-agent.nixosModules.default
    ./agent-user.nix
    ./env.nix
  ];
  nixdots.persist.system = {
    directories = [
      "/var/lib/hermes"
    ];
  };
  # Template for litellm API key (OpenAI-compatible)
  # hermes-agent uses LITELLM_API_KEY to authenticate with litellm proxy

  services.hermes-agent = {
    enable = true;
    package = pkgs.hermes-agent;

    group = "agents";

    # ── Service behavior ─────────────────────────────────────────────
    restart = "always";
    restartSec = 5;

    # Available on system PATH for interactive use
    addToSystemPackages = true;

    mcpServers = {
      filesystem = {
        command = "npx";
        args = [
          "-y"
          "@modelcontextprotocol/server-filesystem"
          "/home/user"
        ];
      };
      tavily = {
        url = "${litellm}/tavily/mcp";
        headers = {
          Authorization = "Bearer \${LITELLM_API_KEY}";
        };
      };
      firecrawl = {
        url = "${litellm}/firecrawl/mcp";
        headers = {
          Authorization = "Bearer \${LITELLM_API_KEY}";
        };
      };
    };
    # ── Declarative settings (deep-merged into config.yaml) ──────────
    settings = {
      # Model — routed through litellm
      custom_providers = [
        {
          name = "litellm";
          base_url = litellm;
          key_env = "LITELLM_API_KEY";
        }
      ];

      model = {
        default = "deepseek-v4-flash";
        provider = "custom:litellm";
      };

      toolsets = [ "hermes-cli" ];

      timezone = "Europe/London";

      display = {
        language = "zh";
      };

      # ── Agent ──────────────────────────────────────────────────────
      agent = {
        max_turns = 90;
        gateway_timeout = 1800;
        restart_drain_timeout = 60;
        tool_use_enforcement = "auto";
        gateway_timeout_warning = 900;
        gateway_notify_interval = 600;
      };

      # ── Terminal ───────────────────────────────────────────────────
      terminal = {
        backend = "local";
        cwd = "/var/lib/hermes";
        timeout = 180;
      };

      # ── Checkpoints ────────────────────────────────────────────────
      checkpoints = {
        enabled = true;
        max_snapshots = 20;
      };

      # ── Compression ────────────────────────────────────────────────
      compression = {
        enabled = true;
        threshold = 0.5;
        target_ratio = 0.2;
        protect_last_n = 20;
      };

      # ── Memory ─────────────────────────────────────────────────────
      memory = {
        memory_enabled = true;
        user_profile_enabled = true;
        memory_char_limit = 2200;
        user_char_limit = 1375;
      };

      # ── Security ───────────────────────────────────────────────────
      security = {
        redact_secrets = true;
        tirith_enabled = true;
        tirith_path = "tirth";
        tirith_timeout = 5;
        tirith_fail_open = true;
      };

      # ── Approvals ──────────────────────────────────────────────────
      approvals = {
        mode = "manual";
        timeout = 60;
      };

      # ── Display ────────────────────────────────────────────────────
      display = {
        personality = "kawaii";
      };

      # ── Web ────────────────────────────────────────────────────────
      web = {
        backend = "tavily";
      };

      # ── TTS ────────────────────────────────────────────────────────
      tts = {
        provider = "edge";
      };

      # ── Session Reset ──────────────────────────────────────────────
      session_reset = {
        mode = "both";
        idle_minutes = 1440;
        at_hour = 4;
      };
    };
  };
}
