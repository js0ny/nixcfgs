{
  flake.nixosModules.opengist =
    {
      config,
      lib,
      secrets,
      ...
    }:
    let
      tag = "1.13.1";

      ep = config.nixdefs.endpoints;
      epSelf = ep.opengist;
      consts = config.nixdefs.consts;
      url = epSelf.domain;
      portStr = epSelf.portStr;
      bindAddress = epSelf.bindAddress;
      srcPath = "/var/lib/opengist";
      internalPort = "6157";
      sshPort = "2222";
    in
    {
      systemd.tmpfiles.rules = [
        "d ${srcPath} 0755 root root -"
      ];

      sops.secrets.opengist_forgejo_oauth_secret = {
        sopsFile = secrets + /opengist.yaml;
      };

      sops.templates."opengist.env".content = /* bash */ ''
        OG_GITEA_SECRET=${config.sops.placeholder.opengist_forgejo_oauth_secret}
      '';

      virtualisation.oci-containers.containers."opengist" = {
        image = "ghcr.io/thomiceli/opengist:${tag}";
        ports = [
          "${bindAddress}:${portStr}:${internalPort}"
          "${sshPort}:2222"
        ];
        volumes = [
          "${srcPath}:/opengist"
        ];
        log-driver = "journald";
        environment = {
          OG_HTTP_HOST = "0.0.0.0";
          OG_HTTP_PORT = internalPort;
          OG_GITEA_URL = "${ep.forgejo.publicUrl}/";
          OG_GITEA_CLIENT_KEY = "10eaa5bc-3741-45d1-bc9f-ff3dad79ad33";
          OG_GITEA_NAME = "Forgejo";
          OG_OIDC_PROVIDER_NAME = consts.oidc.name;
          OG_OIDC_DISCOVERY_URL = consts.oidc.discovery;
          OG_OIDC_CLIENT_KEY = "opengist";
          OG_OIDC_GROUP_CLAIM_NAME = "groups";
          OG_OIDC_ADMIN_GROUP = "admin";
        };
        environmentFiles = [ config.sops.templates."opengist.env".path ];
        extraOptions = [
          "--add-host=${ep.forgejo.domain}:${config.nixdots.services.tailscale.ip}"
        ];
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
    };
}
