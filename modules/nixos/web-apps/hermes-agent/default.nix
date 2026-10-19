{
  flake.nixosModules.hermes-agent =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      inherit (config.services.hermes-agent) user group;
    in
    {
      imports = [
        ./nixos.nix
        ./agent-user.nix
        ./env.nix
        ./workspace-sync.nix
        ./models.nix
        ./mcp-skills.nix
      ];
      js0ny.persist.stores.state.directories = [
        {
          inherit user group;
          directory = "/var/lib/hermes";
          mode = "2770";
        }
      ];

      services.hermes-agent = {
        enable = true;
        package = pkgs.llm-agents.hermes-agent;
        group = "agents";
        dashboard.host = "0.0.0.0";

        # https://github.com/NousResearch/hermes-agent/blob/main/cli-config.yaml.example
        settings = {
          timezone = "Europe/London";

          # ── Agent ──────────────────────────────────────────────────────
          agent = {
            max_turns = 90;
            gateway_timeout = 1800;
            restart_drain_timeout = 60;
            tool_use_enforcement = "auto";
            gateway_timeout_warning = 900;
            gateway_notify_interval = 600;
            image_input_mode = "auto";
            # https://hermes-agent.nousresearch.com/docs/reference/toolsets-reference
            disabled_toolsets = [
              # keep-sorted start
              "computer_use"
              "discord"
              "discord_admin"
              "feishu_doc"
              "feishu_drive"
              "homeassistant"
              "spotify"
              "x_search"
              "yuanbao"
              # keep-sorted end
            ];
          };

          # ── Terminal ───────────────────────────────────────────────────
          terminal = {
            backend = "local";
            home_mode = "real";
            cwd = "/var/lib/hermes/workspace/default";
            timeout = 180;
            persistent_shell = true;
            font_family = "Maple Mono NF CN";
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
            write_approval = true;
          };

          # ── Security ───────────────────────────────────────────────────
          security = {
            redact_secrets = true;

            protected_instruction_files = true;

            tirith_enabled = true;
            tirith_path = lib.getExe pkgs.tirith;
            tirith_timeout = 5;
            tirith_fail_open = true;

            allow_lazy_installs = false;
          };

          # ── Approvals ──────────────────────────────────────────────────
          approvals = {
            mode = "smart";
            timeout = 60 * 5; # seconds
          };

          # ── Display ────────────────────────────────────────────────────
          display = {
            compact = true;
            tool_progress = "all";
            tool_progress_command = true;
            language = "zh";
            resume_display = "full";
            runtime_footer = {
              enabled = true;
            };
            file_mutation_verifier = true;
            show_reasoning = false;
            personality = "kawaii";
            skin = "charizard"; # 增火龙说是
            streaming = true;
            show_cost = true;
            vim_mode = true;
            platforms.telegram = {
              tool_progress = "verbose";
              tool_progress_command = true;
              runtime_footer = {
                enabled = true;
                fields = [
                  "model"
                  "context_pct"
                  "latency"
                ];
              };
              show_commentary = true;
              show_reasoning = true;
            };
          };

          privacy.redact_pii = true;

          streaming = {
            enabled = true;
            transport = "edit";
          };

          # ── Web ────────────────────────────────────────────────────────
          web = {
            backend = "tavily";
            search_backend = "tavily";
            extract_backend = "firecrawl";
          };
          browser = {
            backend = "off";
            cloud_provider = "local";
          };

          # https://hermes-agent.nousresearch.com/docs/user-guide/features/tts
          tts = {
            provider = "edge";
          };

          # ── Session Reset ──────────────────────────────────────────────
          session_reset = {
            mode = "both";
            idle_minutes = 1440; # 24h
            at_hour = 4;
          };
          lsp = {
            enabled = true;
            install_strategy = "manual";
          };

          telemetry = {
            shared_metrics = {
              enabled = false;
              send = false;
            };
          };
          sessions = {
            auto_prune = false;
            auto_archive = true;
            auto_archive_days = 8;
          };
        };
      };

    };

  flake.homeModules.hermes-agent = import ./home.nix;
}
