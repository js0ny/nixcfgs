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
  # https://opengist.io/docs/configuration/cheat-sheet.html
  settings = {
    opengist-home = stateDir;
    "http.host" = bindAddress;
    "http.port" = lib.toInt portStr;
    log-level = "warn";
    log-output = "stdout,file";
    "metrics.enabled" = true;
    "metrics.host" = "127.0.0.1";
    "metrics.port" = 6158;
    "ssh.host" = "0.0.0.0";
    "ssh.port" = sshPort;
    "gitea.url" = "${ep.forgejo.publicUrl}/";
    "gitea.client-key" = "10eaa5bc-3741-45d1-bc9f-ff3dad79ad33";
    "gitea.name" = "Forgejo";
    # oidc
    "oidc.provider-name" = consts.oidc.name;
    "oidc.client-key" = "opengist";
    "oidc.discovery-url" = consts.oidc.discovery;
    "oidc.group-claim-name" = "groups";
    "oidc.admin-group" = "admin";
  }
  // lib.optionalAttrs (epSelf.publicUrl != null) {
    external-url = epSelf.publicUrl;
  };
  configFile = (pkgs.formats.yaml { }).generate "opengist.yml" settings;
  sopsFile = secrets + "/opengist.yaml";
in
{
  sops.secrets = {
    opengist_forgejo_oauth_secret = { inherit sopsFile; };
    opengist_oidc_secret = { inherit sopsFile; };
  };

  sops.templates."opengist.env".content = myLib.attrsToEnvFile {
    OG_GITEA_SECRET = config.sops.placeholder.opengist_forgejo_oauth_secret;
    OG_OIDC_SECRET = config.sops.placeholder.opengist_oidc_secret;
  };

  users.users.opengist = {
    isSystemUser = true;
    group = "opengist";
  };
  users.groups.opengist = { };

  systemd.services.opengist = {
    description = "Opengist service";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    path = [ pkgs.git ];
    environment.HOME = stateDir;
    serviceConfig = {
      User = "opengist";
      Group = "opengist";
      StateDirectory = "opengist";
      StateDirectoryMode = "0750";
      WorkingDirectory = stateDir;
      EnvironmentFile = config.sops.templates."opengist.env".path;
      ExecStart = lib.escapeShellArgs [
        (lib.getExe pkgs.opengist)
        "--config"
        configFile
      ];
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
}
