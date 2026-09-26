{
  config,
  lib,
  pkgs,
  ...
}:
let
  moduleLib = import ./module-lib.nix { inherit lib; };
  cfg = config.services.hermes-agent;
  runtime = moduleLib.mkRuntime {
    inherit pkgs cfg;
    configMode = "0600";
    directoryMode = "0700";
  };
  serviceEnvironment = cfg.environment // {
    HERMES_HOME = cfg.home;
    HOME = config.home.homeDirectory;
  };
  environment = lib.mapAttrsToList (name: value: "${name}=${toString value}") serviceEnvironment;
  commonService = {
    Environment = environment;
    ExecStartPre = lib.getExe runtime.setup;
    Restart = cfg.restart;
    RestartSec = cfg.restartSec;
    WorkingDirectory = cfg.workingDirectory;
  }
  // lib.optionalAttrs (cfg.environmentFiles != [ ]) {
    EnvironmentFile = cfg.environmentFiles;
  };
in
{
  options.services.hermes-agent = moduleLib.mkOptions {
    inherit pkgs;
    defaultHome = "${config.xdg.configHome}/hermes-agent";
    defaultWorkingDirectory = config.home.homeDirectory;
    defaultDashboardEnable = true;
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

    home = {
      packages = [ cfg.package ] ++ cfg.extraPackages;
      sessionVariables.HERMES_HOME = cfg.home;
    };

    systemd.user.services = {
      hermes-agent = lib.mkIf cfg.gateway.enable {
        Unit.Description = "Hermes Agent Gateway";
        Service = commonService // {
          ExecStart = lib.escapeShellArgs (
            [
              (lib.getExe cfg.package)
              "gateway"
              "run"
            ]
            ++ cfg.gateway.extraArgs
          );
        };
        Install.WantedBy = [ "default.target" ];
      };

      hermes-dashboard = lib.mkIf cfg.dashboard.enable {
        Unit.Description = "Hermes Agent Dashboard";
        Service = commonService // {
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
        Install.WantedBy = [ "default.target" ];
      };
    };
  };
}
