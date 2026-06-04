{
  config,
  lib,
  secrets,
  ...
}:
let
  ep = config.nixdefs.endpoints;
  epSelf = ep.miniflux;
  url = epSelf.domain;
  socketPath = "/run/miniflux/miniflux.sock";
  dbname = "miniflux";
  dbuser = "miniflux";
  selfhosted = config.nixdefs.selfhosted;
  inherit (lib) mkDefault mkIf;
in
{
  sops.secrets = {
    miniflux_admin_username = {
      sopsFile = secrets + /miniflux.yaml;
    };
    miniflux_admin_password = {
      sopsFile = secrets + /miniflux.yaml;
    };
    miniflux_db_password = {
      sopsFile = secrets + /miniflux.yaml;
    };
    miniflux_oidc_secret = {
      sopsFile = secrets + /miniflux.yaml;
    };
  };

  sops.templates."miniflux.env".content = /* bash */ ''
    ADMIN_USERNAME="${config.sops.placeholder.miniflux_admin_username}"
    ADMIN_PASSWORD="${config.sops.placeholder.miniflux_admin_password}"
    OAUTH2_CLIENT_SECRET="${config.sops.placeholder.miniflux_oidc_secret}"
    # DATABASE_URL='postgres://${dbuser}:${config.sops.placeholder.miniflux_db_password}@127.0.0.1:5432/${dbname}?sslmode=disable'
  '';

  services.miniflux = {
    enable = true;
    config = lib.mkMerge [
      {
        CLEANUP_FREQUENCY = mkDefault 48;
        WEBAUTHN = mkDefault "1";
        LISTEN_ADDR = socketPath;
        CREATE_ADMIN = mkDefault 1;
        FETCHER_ALLOW_PRIVATE_NETWORKS = mkDefault "1";
      }
      (mkIf (url != null) {
        BASE_URL = epSelf.publicUrl;
      })
      (mkIf (selfhosted.openid.enable) {
        OAUTH2_PROVIDER = "oidc";
        OAUTH2_CLIENT_ID = "miniflux";
        OAUTH2_OIDC_DISCOVERY_ENDPOINT = ep.authelia.publicUrl;
        OAUTH2_REDIRECT_URL = "${epSelf.publicUrl}/oauth2/oidc/callback";
        OAUTH2_USER_CREATION = "1";
        OAUTH2_OIDC_PROVIDER_NAME = selfhosted.openid.name;
      })
    ];
    adminCredentialsFile = config.sops.templates."miniflux.env".path;
    createDatabaseLocally = true;
  };

  services.nginx.virtualHosts = mkIf (url != null) {
    ${url} = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://unix:${socketPath}:/";
      };
    }
    // config.nixdefs.consts.nginxWithCF;
  };

  systemd.services.miniflux.serviceConfig = {
    DynamicUser = lib.mkForce false;
    RuntimeDirectoryMode = lib.mkForce "0770";
    UMask = lib.mkForce "0007";
    User = "miniflux";
    Group = "miniflux";
  };

  users.users.miniflux = {
    group = "miniflux";
    isSystemUser = true;
  };
  users.groups.miniflux.members = [ "nginx" ];
}
