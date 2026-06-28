{
  flake.nixosModules.hermes-agent =
    {
      inputs,
      config,
      pkgs,
      lib,
      myLib,
      ...
    }:
    let
      models = config.nixdefs.llm.routing;
      litellm = config.nixdefs.endpoints.litellm.publicUrl;
      system = pkgs.stdenv.hostPlatform.system;
    in
    {
      environment.variables = {
        HERMES_HOME = "/var/lib/hermes/.hermes";
      };
      imports = [
        inputs.hermes-agent.nixosModules.default
        ./agent-user.nix
        ./env.nix
        ./lmwiki.nix
        ./hermes-dashboard.nix
      ];
      nixdots.persist.system = {
        directories = [
          "/var/lib/hermes"
        ];
      };

      services.hermes-agent = {
        enable = true;
        package = inputs.hermes-agent.packages.${system}.full;

        group = "agents";

        # ── Service behavior ─────────────────────────────────────────────
        restart = "always";
        restartSec = 5;

        # Available on system PATH for interactive use
        addToSystemPackages = true;

        mcpServers = {
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
          github = {
            url = "https://api.githubcopilot.com/mcp/";
            headers.Authorization = "Bearer \${GITHUB_TOKEN}";
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
            default = models.agent.model;
            provider = "custom:litellm";
          };

          auxiliary = {
            vision = {
              provider = "custom:litellm";
              model = models.vision.model;
            };
          };

          toolsets = [ "hermes-cli" ];

          timezone = "Europe/London";

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
            persistent_shell = true;
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
            tirith_path = lib.getExe pkgs.tirith;
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
            language = "zh";
            personality = "kawaii";
            skin = "charizard"; # 增火龙说是
            streaming = true;
            show_cost = true;
          };

          privacy = {
            redact_pii = true;
          };

          streaming = {
            enabled = true;
            trnsfport = "edit";
          };

          # ── Web ────────────────────────────────────────────────────────
          web = {
            backend = "tavily";
            search_backend = "tavily";
            extract_backend = "firecrawl";
          };

          # https://hermes-agent.nousresearch.com/docs/user-guide/features/tts
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
    };
}
