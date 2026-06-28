{
  flake.nixosModules.karakeep =
    {
      pkgs,
      lib,
      config,
      secrets,
      ...
    }:
    let
      ep = config.nixdefs.endpoints;
      epSelf = ep.karakeep;
      consts = config.nixdefs.consts;
      url = epSelf.domain;
      portStr = epSelf.portStr;
      browserPort = epSelf.port + 1;
    in
    {
      services.karakeep = {
        enable = true;
        browser = {
          port = browserPort;
        };
        extraEnvironment = {
          PORT = portStr;
          # DISABLE_SIGNUPS = "true";
          DISABLE_NEW_RELEASE_CHECK = "true";
          LOG_LEVEL = "notice";
          NEXTAUTH_URL = epSelf.publicUrl;
          OAUTH_WELLKNOWN_URL = consts.oidc.discovery;
          OAUTH_CLIENT_ID = "karakeep";
          OAUTH_PROVIDER_NAME = consts.oidc.name;
        };
        environmentFile = config.sops.templates."karakeep.env".path;
      };
      sops.secrets = {
        karakeep_secret = {
          sopsFile = secrets + /karakeep.yaml;
        };
        karakeep_oidc_secret = {
          sopsFile = secrets + /karakeep.yaml;
        };
      };
      sops.templates."karakeep.env".content = /* bash */ ''
        NEXTAUTH_SECRET=${config.sops.placeholder.karakeep_secret}
        OAUTH_CLIENT_SECRET=${config.sops.placeholder.karakeep_oidc_secret}
      '';

      services.nginx.virtualHosts = lib.mkIf (url != null) {
        ${url} = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://localhost:${portStr}";
          };
        }
        // config.nixdefs.consts.nginxWithCF;
      };
      nixdots.persist.system = {
        directories = [
          "/var/lib/karakeep"
        ];
      };
    };
}
