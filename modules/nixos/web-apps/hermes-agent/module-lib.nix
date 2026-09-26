{ lib }:
{
  mkOptions =
    {
      pkgs,
      defaultHome,
      defaultWorkingDirectory,
      defaultDashboardEnable ? false,
      defaultGatewayEnable ? false,
    }:
    {
      enable = lib.mkEnableOption "Hermes Agent";

      package = lib.mkPackageOption pkgs.llm-agents "hermes-agent" { };

      home = lib.mkOption {
        type = lib.types.str;
        default = defaultHome;
        description = "Writable HERMES_HOME containing configuration and runtime state.";
      };

      workingDirectory = lib.mkOption {
        type = lib.types.str;
        default = defaultWorkingDirectory;
        description = "Default workspace exposed to Hermes terminal tools.";
      };

      settings = lib.mkOption {
        type = lib.types.attrs;
        default = { };
        description = "Settings merged into the writable config.yaml before Hermes starts.";
      };

      mcpServers = lib.mkOption {
        type = lib.types.attrs;
        default = { };
        description = "MCP server definitions merged into config.yaml under mcp_servers.";
      };

      environment = lib.mkOption {
        type = with lib.types; attrsOf str;
        default = { };
        description = "Environment variables supplied to Hermes services.";
      };

      environmentFiles = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
        description = "Environment files supplied to Hermes services outside the Nix store.";
      };

      extraPackages = lib.mkOption {
        type = with lib.types; listOf package;
        default = [ ];
        description = "Packages added to the service PATH for terminal tool use.";
      };

      gateway = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = defaultGatewayEnable;
          description = "Whether to run the messaging gateway.";
        };
        extraArgs = lib.mkOption {
          type = with lib.types; listOf str;
          default = [ ];
          description = "Additional arguments passed to hermes gateway run.";
        };
      };

      dashboard = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = defaultDashboardEnable;
          description = "Whether to run the Hermes web dashboard.";
        };
        host = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = "Dashboard listen address.";
        };
        port = lib.mkOption {
          type = lib.types.port;
          default = 9119;
          description = "Dashboard listen port.";
        };
        extraArgs = lib.mkOption {
          type = with lib.types; listOf str;
          default = [ ];
          description = "Additional arguments passed to hermes dashboard.";
        };
      };

      restart = lib.mkOption {
        type = lib.types.str;
        default = "always";
        description = "systemd restart policy for Hermes services.";
      };

      restartSec = lib.mkOption {
        type = lib.types.int;
        default = 5;
        description = "Delay in seconds before restarting Hermes services.";
      };
    };

  mkRuntime =
    {
      pkgs,
      cfg,
      configMode,
      directoryMode,
    }:
    let
      settingsWithWorkspace = lib.recursiveUpdate {
        terminal.cwd = cfg.workingDirectory;
      } cfg.settings;
      settings =
        if cfg.mcpServers == { } then
          settingsWithWorkspace
        else
          lib.recursiveUpdate settingsWithWorkspace {
            mcp_servers = cfg.mcpServers;
          };
      generatedConfig = pkgs.writeText "hermes-config.json" (builtins.toJSON settings);
      mergeConfig =
        pkgs.writers.writePython3Bin "hermes-merge-config"
          {
            libraries = [ pkgs.python3Packages.pyyaml ];
          }
          /* python */ ''
            import os
            import sys
            import tempfile
            from pathlib import Path

            import yaml

            source = Path(sys.argv[1])
            destination = Path(sys.argv[2])
            mode = int(sys.argv[3], 8)

            declared = yaml.safe_load(source.read_text()) or {}
            if not isinstance(declared, dict):
                raise TypeError("the declared Hermes configuration must be a mapping")

            existing = {}
            if destination.exists():
                existing = yaml.safe_load(destination.read_text()) or {}
                if not isinstance(existing, dict):
                    raise TypeError(f"{destination} must contain a mapping")


            def deep_merge(base, override):
                result = dict(base)
                for key, value in override.items():
                    if isinstance(result.get(key), dict) and isinstance(value, dict):
                        result[key] = deep_merge(result[key], value)
                    else:
                        result[key] = value
                return result


            destination.parent.mkdir(parents=True, exist_ok=True)
            with tempfile.NamedTemporaryFile(
                mode="w",
                encoding="utf-8",
                dir=destination.parent,
                prefix=f".{destination.name}.",
                delete=False,
            ) as temporary:
                yaml.safe_dump(
                    deep_merge(existing, declared),
                    temporary,
                    default_flow_style=False,
                    sort_keys=False,
                    allow_unicode=True,
                )
                temporary.flush()
                os.fsync(temporary.fileno())
                temporary_path = Path(temporary.name)

            try:
                os.chmod(temporary_path, mode)
                os.replace(temporary_path, destination)
            finally:
                temporary_path.unlink(missing_ok=True)
          '';
      setup = pkgs.writeShellApplication {
        name = "hermes-setup";
        runtimeInputs = [
          pkgs.coreutils
          pkgs.util-linux
        ];
        text = /* bash */ ''
          install -d -m ${directoryMode} ${lib.escapeShellArg cfg.home}
          mkdir -p ${lib.escapeShellArg cfg.workingDirectory}
          rm -f ${lib.escapeShellArg "${cfg.home}/.managed"}
          exec flock ${lib.escapeShellArg "${cfg.home}/.nix-config.lock"} \
            ${lib.getExe mergeConfig} \
            ${lib.escapeShellArg generatedConfig} \
            ${lib.escapeShellArg "${cfg.home}/config.yaml"} \
            ${configMode}
        '';
      };
    in
    {
      inherit generatedConfig settings setup;
    };
}
