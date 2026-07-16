{
  flake.nixosModules.hermes-agent =
    {
      inputs,
      pkgs,
      lib,
      ...
    }:
    let
      system = pkgs.stdenv.hostPlatform.system;
    in
    {
      # https://hermes-agent.nousresearch.com/docs/developer-guide/prompt-assembly
      environment.variables = {
        HERMES_HOME = "/var/lib/hermes/.hermes";
      };
      imports = [
        inputs.hermes-agent.nixosModules.default
        ./agent-user.nix
        ./env.nix
        ./lmwiki.nix
        ./hermes-dashboard.nix
        ./models.nix
        ./mcp-skills.nix
      ];
      nixdots.persist.system = {
        directories = [
          "/var/lib/hermes"
        ];
      };

      services.hermes-agent = {
        enable = true;
        package = inputs.hermes-agent.packages.${system}.messaging;
        group = "agents";
        restart = "always";
        restartSec = 5;
        addToSystemPackages = true;

        # https://github.com/NousResearch/hermes-agent/blob/main/cli-config.yaml.example
        settings = {
          _config_version = 33;
          # Model — routed through litellm

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
            write_approval = true;
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
            mode = "smart";
            timeout = 60;
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
            platforms.telegram = {
              tool_progress = "off";
              tool_progress_command = false;
              runtime_footer.enabled = false;
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
        };
      };

    };
}
