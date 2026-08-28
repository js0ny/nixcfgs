{
  flake.nixosModules.papra =
    {
      config,
      secrets,
      lib,
      ...
    }:
    let
      ep = config.nixdefs.endpoints;
      epSelf = ep.papra;
      portStr = epSelf.portStr;
      url = epSelf.domain;
      authConfig = [
        {
          providerId = "authelia";
          providerName = "Authelia";
          providerIconUrl = "https://www.authelia.com/images/branding/logo-cropped.png";
          clientId = "papra";
          clientSecret = config.sops.placeholder.papra_oidc_secret;
          pkce = true;
          type = "oidc";
          discoveryUrl = "${ep.authelia.publicUrl}/.well-known/openid-configuration";
          scopes = [
            "openid"
            "profile"
            "email"
          ];
        }
      ];
    in
    {
      sops.templates."papra.env".content = /* bash */ ''
        AUTH_PROVIDERS_CUSTOMS=${builtins.toJSON authConfig}
      '';
      sops.secrets = {
        papra_oidc_secret = {
          sopsFile = secrets + "/papra.yaml";
        };
      };
      services.papra = {
        enable = true;
        environment = {
          PROCESS_MODE = "all";
          SERVER_HOSTNAME = epSelf.bindAddress;
          PORT = epSelf.port;
          APP_BASE_URL = epSelf.publicUrl;
        };
        environmentFile = config.sops.templates."papra.env".path;
      };

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
    };
}
