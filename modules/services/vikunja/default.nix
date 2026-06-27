{
  lib,
  config,
  secrets,
  ...
}:
let
  ep = config.nixdefs.endpoints;
  epSelf = ep.vikunja;
  url = epSelf.domain;
  sopsFile = secrets + /vikunja.yaml;
in
{
  sops.secrets = {
    vikunja_service_secret = { inherit sopsFile; };
    vikunja_oidc_secret = { inherit sopsFile; };
  };
  sops.templates."vikunja.env".content = /* bash */ ''
    VIKUNJA_SERVICE_SECRET=${config.sops.placeholder.vikunja_service_secret}
    VIKUNJA_AUTH_OPENID_PROVIDERS_AUTHELIA_CLIENTSECRET=${config.sops.placeholder.vikunja_oidc_secret}
  '';
  services.vikunja = {
    enable = true;
    address = epSelf.bindAddress;
    frontendHostname = url;
    port = epSelf.port;
    environmentFiles = [ config.sops.templates."vikunja.env".path ];
    frontendScheme = "https";
    database.type = "sqlite";
    #  https://vikunja.io/docs/config-options/
    settings = {
      service = {
        enablelinksharing = false;
        enableregistration = false;
        # publicurl = epSelf.publicUrl; # use upstream definitions
        enablecaldav = true;
      };
      auth.openid = {
        enabled = true;
        providers = {
          authelia = {
            name = "Authelia";
            authurl = ep.authelia.publicUrl;
            clientid = "vikunja";
            scope = lib.concatStringsSep " " [
              "openid"
              "profile"
              "email"
            ];
          };
        };
      };

      redis.enabled = false;
      keyvalue.type = "memory";
      mailer.enabled = false;
      metrics = {
        enabled = false;
      };
      log = {
        enabled = true;
        http = "file";
        path = "/var/lib/vikunja/logs";
      };
    };
  };

  services.fail2ban.jails.vikunja.settings = {
    enabled = true;
    backend = "auto";
    filter = "vikunja";
    port = "http,https";
    logpath = "/var/lib/vikunja/logs/http.log";
    maxretry = 3;
    findtime = 600;
    bantime = 3600;
  };

  environment.etc."fail2ban/filter.d/vikunja.conf".text = /* ini */ ''
    [Definition]
    datepattern = ^time=%%Y-%%m-%%dT%%H:%%M:%%S%%Z
    failregex = ^.*\bmsg="POST\s+/api/v\d+/login[^"]*".*\bstatus=(?:400|403|412)\b.*\bremote_ip=<HOST>\b.*$
  '';

  systemd.services.vikunja.serviceConfig.SupplementaryGroups = [ config.services.nginx.group ];
  services.nginx.virtualHosts = lib.mkIf (url != null) {
    ${url} = {
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:${epSelf.portStr}/";
      };
    }
    // config.nixdefs.consts.nginxWithCF;
  };
}
