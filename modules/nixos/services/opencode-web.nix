{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.services.opencode-web;
  description = "Opencode: The open source coding agent.";
in
{
  options.services.opencode-web = {
    enable = lib.mkEnableOption description;

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.opencode;
      description = "Opencode package to use.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 4096;
      description = "Port for Opencode to listen on.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Hostname or IP address to bind to. Use 0.0.0.0 to expose on network.";
    };

    mdns = {
      enable = lib.mkEnableOption "mDNS discovery on the local network";
      domain = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "myproject.local";
        description = "Custom mDNS domain name. If null, opencode defaults to opencode.local.";
      };
    };

    cors = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "https://example.com" ];
      description = "List of allowed CORS domains.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "opencode";
      description = "System user running opencode.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "opencode";
      description = "System group running opencode.";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/opencode";
      description = "Working directory for Opencode.";
    };

    envFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Optional environment file passed to systemd via EnvironmentFile.
        Intended for secrets like OPENCODE_SERVER_PASSWORD and OPENCODE_SERVER_USERNAME.
      '';
    };

    extraEnvironment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Extra plain-text environment variables for Opencode.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the configured port in the firewall.";
    };

    workspacePaths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "/srv/git"
        "/var/www"
        "/home/user/projects"
      ];
      description = "Directories outside the sandbox that Opencode needs read and write access to.";
    };

    allowHomeAccess = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Set to true if any of your workspacePaths are located inside /home. This disables ProtectHome.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.${cfg.group} = { };
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.dataDir;
      createHome = true;
      description = "Opencode Web Service User";
    };

    environment.systemPackages = [ cfg.package ];

    systemd.services.opencode-web =
      let
        args = [
          "web"
          "--port"
          (toString cfg.port)
          "--hostname"
          cfg.hostname
        ]
        ++ lib.optionals cfg.mdns.enable (
          [ "--mdns" ]
          ++ lib.optionals (cfg.mdns.domain != null) [
            "--mdns-domain"
            cfg.mdns.domain
          ]
        )
        ++ lib.concatMap (domain: [
          "--cors"
          domain
        ]) cfg.cors;
      in
      {
        description = description;
        after = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];
        environment = cfg.extraEnvironment;

        serviceConfig = {
          ExecStart = "${lib.getExe cfg.package} ${lib.escapeShellArgs args}";
          Restart = "always";
          RestartSec = "10s";
          User = cfg.user;
          Group = cfg.group;
          WorkingDirectory = cfg.dataDir;
          StateDirectory = "opencode";
          CacheDirectory = "opencode";
          PrivateTmp = true;
          NoNewPrivileges = true;
          ProtectSystem = "strict";
          ProtectHome = if cfg.allowHomeAccess then false else true;
        }
        // lib.optionalAttrs (cfg.envFile != null) {
          EnvironmentFile = cfg.envFile;
        }
        // lib.optionalAttrs (builtins.length cfg.workspacePaths > 0) {
          ReadWritePaths = cfg.workspacePaths;
        };
      };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };
}
