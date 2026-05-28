{
  pkgs,
  lib,
  config,
  secrets,
  ...
}:
let
  ep = config.nixdefs.endpoints;
  epSelf = ep.paperless;
  consts = config.nixdefs.consts;
  url = epSelf.domain;
  portStr = epSelf.portStr;
  bindAddress = epSelf.bindAddress;
  tailscale = config.nixdots.services.tailscale.ip;
in
{
  sops.secrets = {
    paperless_secret_key = {
      sopsFile = secrets + /paperless.yaml;
    };
    paperless_oidc_secret = {
      sopsFile = secrets + /paperless.yaml;
    };
  };

  sops.templates."paperless.env".content =
    let
      provider = {
        openid_connect = {
          SCOPE = [
            "openid"
            "profile"
            "email"
          ];
          OAUTH_PKCE_ENABLED = true;
          APPS = [
            {
              provider_id = lib.toLower consts.oidc.name;
              name = consts.oidc.name;
              client_id = "paperless";
              secret = config.sops.placeholder.paperless_oidc_secret;
              settings = {
                server_url = ep.authelia.publicUrl;
                token_auth_method = "client_secret_basic";
              };
            }
          ];
        };
      };
    in
    /* bash */ ''
      PAPERLESS_SECRET_KEY=${config.sops.placeholder.paperless_secret_key}
      PAPERLESS_SOCIALACCOUNT_PROVIDERS=${builtins.toJSON provider}
    '';

  services.paperless = {
    package = pkgs.paperless-ngx;
    address = bindAddress;
    enable = true;
    domain = url;
    port = epSelf.port;
    environmentFile = config.sops.templates."paperless.env".path;
    settings = {
      PAPERLESS_ALLOWED_HOSTS = "${url},${tailscale}";
      PAPERLESS_ACCOUNT_ALLOW_SIGNUPS = "False";
      PAPERLESS_APPS = "allauth.socialaccount.providers.openid_connect";
    };
  };

  services.nginx.virtualHosts = lib.mkIf (url != null) {
    ${url} = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:${portStr}";
      };
    };
  };
}
