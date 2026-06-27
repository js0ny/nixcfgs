{
  flake.nixosModules.radicale =
    {
      config,
      lib,
      secrets,
      ...
    }:
    let
      ep = config.nixdefs.endpoints;
      epSelf = ep.radicale;
      url = epSelf.domain;
      portStr = epSelf.portStr;
      bindAddress = epSelf.bindAddress;
      stateDir = "/var/lib/radicale";
      serviceUser = config.systemd.services.radicale.serviceConfig.User;
      serviceGroup = config.systemd.services.radicale.serviceConfig.Group;
    in
    {
      sops.secrets.radicale_htpasswd = {
        sopsFile = secrets + /radicale.yaml;
        owner = serviceUser;
        group = serviceGroup;
        mode = "0400";
      };

      services.radicale = {
        enable = true;
        settings = {
          server.hosts = [
            "${bindAddress}:${portStr}"
            "[::]:${portStr}"
          ];
          auth = {
            type = "htpasswd";
            htpasswd_filename = config.sops.secrets.radicale_htpasswd.path;
            htpasswd_encryption = "bcrypt";
          };
          storage.filesystem_folder = "${stateDir}/collections";
        };
      };

      nixdots.persist.system.directories = [ stateDir ];

      services.nginx.virtualHosts = lib.mkIf (url != null) {
        ${url} = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://localhost:${portStr}";
            extraConfig = /* nginx */ ''
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Host $host;
              proxy_set_header X-Forwarded-Port $server_port;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header Host $host;
              proxy_pass_header Authorization;
            '';
          };
        };
      };
    };
}
