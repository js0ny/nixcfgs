{
  config,
  lib,
  pkgs,
  ...
}:
let
  moduleLib = import ./module-lib.nix { inherit lib; };
  cfg = config.services.hermes-agent;
  userHome = builtins.dirOf cfg.home;
  runtime = moduleLib.mkRuntime {
    inherit pkgs cfg;
    configMode = "0660";
    directoryMode = "2770";
  };
  serviceEnvironment = cfg.environment // {
    HERMES_HOME = cfg.home;
    HOME = userHome;
  };
  commonServiceConfig = {
    User = cfg.user;
    Group = cfg.group;
    WorkingDirectory = cfg.workingDirectory;
    ExecStartPre = lib.getExe runtime.setup;
    Restart = cfg.restart;
    RestartSec = cfg.restartSec;
    UMask = "0007";
    NoNewPrivileges = true;
    PrivateTmp = true;
    ProtectClock = true;
    ProtectControlGroups = true;
    ProtectHome = true;
    ProtectHostname = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    RestrictSUIDSGID = true;
  }
  // lib.optionalAttrs (cfg.environmentFiles != [ ]) {
    EnvironmentFile = cfg.environmentFiles;
  };
in
{
  options.services.hermes-agent =
    moduleLib.mkOptions {
      inherit pkgs;
      defaultHome = "/var/lib/hermes/.hermes";
      defaultWorkingDirectory = "/var/lib/hermes";
      defaultDashboardEnable = true;
      defaultGatewayEnable = true;
    }
    // {
      user = lib.mkOption {
        type = lib.types.str;
        default = "hermes";
        description = "System user running Hermes Agent.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "hermes";
        description = "System group running Hermes Agent.";
      };

      addToSystemPackages = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to install the Hermes CLI system-wide.";
      };
    };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.gateway.enable || cfg.dashboard.enable;
        message = "services.hermes-agent requires gateway.enable or dashboard.enable";
      }
      {
        assertion = lib.hasPrefix "/" cfg.home && lib.hasPrefix "/" cfg.workingDirectory;
        message = "services.hermes-agent home and workingDirectory must be absolute paths";
      }
    ];

    users.groups.${cfg.group} = { };
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = userHome;
      createHome = true;
      homeMode = "2770";
      packages = cfg.extraPackages;
    };

    environment = {
      systemPackages = lib.optional cfg.addToSystemPackages cfg.package;
      variables.HERMES_HOME = cfg.home;
    };

    systemd.tmpfiles.rules = lib.unique [
      "d ${userHome} 2770 ${cfg.user} ${cfg.group} -"
      "A+ ${userHome} - - - - g:${cfg.group}:rwX,d:g:${cfg.group}:rwX"
      "d ${cfg.home} 2770 ${cfg.user} ${cfg.group} -"
      "A+ ${cfg.home} - - - - g:${cfg.group}:rwX,d:g:${cfg.group}:rwX"
      "d ${cfg.workingDirectory} 2770 ${cfg.user} ${cfg.group} -"
      "A+ ${cfg.workingDirectory} - - - - g:${cfg.group}:rwX,d:g:${cfg.group}:rwX"
    ];

    systemd.services = {
      hermes-agent = lib.mkIf cfg.gateway.enable {
        description = "Hermes Agent Gateway";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        environment = serviceEnvironment;
        path = cfg.extraPackages;
        restartTriggers = [ runtime.generatedConfig ];
        serviceConfig = commonServiceConfig // {
          ExecStart = lib.escapeShellArgs (
            [
              (lib.getExe cfg.package)
              "gateway"
              "run"
            ]
            ++ cfg.gateway.extraArgs
          );
        };
      };

      hermes-dashboard = lib.mkIf cfg.dashboard.enable {
        description = "Hermes Agent Dashboard";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        environment = serviceEnvironment;
        path = cfg.extraPackages;
        restartTriggers = [ runtime.generatedConfig ];
        serviceConfig = commonServiceConfig // {
          ExecStart = lib.escapeShellArgs (
            [
              (lib.getExe cfg.package)
              "dashboard"
              "--host"
              cfg.dashboard.host
              "--port"
              (toString cfg.dashboard.port)
              "--no-open"
              "--skip-build"
            ]
            ++ cfg.dashboard.extraArgs
          );
          ExecStop = "-${lib.getExe cfg.package} dashboard --stop";
        };
      };
    };
  };
}
