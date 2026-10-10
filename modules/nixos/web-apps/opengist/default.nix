{
  flake.nixosModules.opengist =
    {
      pkgs,
      lib,
      config,
      secrets,
      myLib,
      ...
    }:
    let
      ep = config.nixdefs.endpoints;
      epSelf = ep.opengist;
      consts = config.nixdefs.consts;
      url = epSelf.domain;
      portStr = epSelf.portStr;
      bindAddress = epSelf.bindAddress;
      stateDir = "/var/lib/opengist";
      sshPort = 2222;
    in
    {
      sops.secrets.opengist_forgejo_oauth_secret = {
        sopsFile = secrets + "/opengist.yaml";
      };

      sops.templates."opengist.env".content = myLib.attrsToEnvFile {
        OG_GITEA_SECRET = config.sops.placeholder.opengist_forgejo_oauth_secret;
      };

      users.users.opengist = {
        isSystemUser = true;
        group = "opengist";
      };
      users.groups.opengist = { };

      systemd.services.opengist = {
        description = "Opengist pastebin service";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        path = [ pkgs.git ];
        environment = {
          HOME = stateDir;
          OG_OPENGIST_HOME = stateDir;
          OG_HTTP_HOST = bindAddress;
          OG_HTTP_PORT = portStr;
          OG_LOG_LEVEL = "warn";
          OG_LOG_OUTPUT = "stdout,file";
          OG_METRICS_ENABLED = "true";
          OG_METRICS_HOST = "127.0.0.1";
          OG_METRICS_PORT = "6158";
          OG_SSH_HOST = "0.0.0.0";
          OG_SSH_PORT = toString sshPort;
          OG_GITEA_URL = "${ep.forgejo.publicUrl}/";
          OG_GITEA_CLIENT_KEY = "10eaa5bc-3741-45d1-bc9f-ff3dad79ad33";
          OG_GITEA_NAME = "Forgejo";
          OG_OIDC_PROVIDER_NAME = consts.oidc.name;
          OG_OIDC_DISCOVERY_URL = consts.oidc.discovery;
          OG_OIDC_CLIENT_KEY = "opengist";
          OG_OIDC_GROUP_CLAIM_NAME = "groups";
          OG_OIDC_ADMIN_GROUP = "admin";
        }
        // lib.optionalAttrs (epSelf.publicUrl != null) {
          OG_EXTERNAL_URL = epSelf.publicUrl;
        };
        serviceConfig = {
          User = "opengist";
          Group = "opengist";
          StateDirectory = "opengist";
          StateDirectoryMode = "0750";
          WorkingDirectory = stateDir;
          EnvironmentFile = config.sops.templates."opengist.env".path;
          ExecStart = lib.getExe pkgs.opengist;
          Restart = "on-failure";
          RestartSec = "5s";
          NoNewPrivileges = true;
          PrivateTmp = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          ReadWritePaths = [ stateDir ];
        };
      };

      environment.etc."fail2ban/filter.d/opengist.conf".text = /* ini */ ''
        [Definition]
        failregex = Invalid .* authentication attempt from <HOST>
        ignoreregex =
      '';

      services.fail2ban.jails.opengist.settings = {
        enabled = true;
        filter = "opengist";
        backend = "auto";
        logpath = "${stateDir}/log/opengist.log";
        maxretry = 10;
        findtime = 3600;
        bantime = 600;
        banaction = "nftables-allports";
        port = "anyport";
      };

      networking.hosts = lib.mkIf (ep.forgejo.domain != null) {
        ${config.js0ny.tailscale.ipv4} = [ ep.forgejo.domain ];
      };
      networking.firewall.allowedTCPPorts = [ sshPort ];
      js0ny.persist.stores.state.directories = [ stateDir ];

      services.nginx.virtualHosts = lib.mkIf (url != null) {
        ${url} = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://localhost:${portStr}";
            recommendedProxySettings = true;
          };
        };
      };
    };
}
