{
  config,
  lib,
  secrets,
  ...
}:
let
  ep = config.nixdefs.endpoints;
  domain = "js0ny.net";
  matrixPortStr = ep.matrix.portStr;
  port = ep.matrix-hookshot.port;
  webhookPortStr = ep.hookshot-webhooks.portStr;
  botID = "webhook";
in
{
  sops.secrets = {
    hookshot_as = {
      sopsFile = secrets + /matrix.yaml;
    };
    hookshot_hs = {
      sopsFile = secrets + /matrix.yaml;
    };
  };

  sops.templates."hookshot-registration.yaml" = {
    content = /* yaml */ ''
      id: ${botID}
      as_token: ${config.sops.placeholder.hookshot_as}
      hs_token: ${config.sops.placeholder.hookshot_hs}
      namespaces:
          users:
          - exclusive: true
            regex: '@_${botID}_.*:${domain}'
          - exclusive: true
            regex: '@${botID}:${domain}'
          aliases:
          - exclusive: true
            regex: \#${botID}_.*:${domain}
      url: http://localhost:${toString port}
      sender_localpart: ${botID}
      rate_limited: false
    '';
    path = "/var/lib/tuwunel/appservices/hookshot-registration.yaml";
    mode = "0700";
    owner = "tuwunel";
    group = "tuwunel";
  };

  services.matrix-hookshot = {
    enable = true;
    registrationFile = config.sops.templates."hookshot-registration.yaml".path;
    serviceDependencies = [ "tuwunel.service" ];
    settings = {
      bridge = {
        domain = domain;
        url = "http://localhost:${matrixPortStr}";
        port = port;
        bindAddress = "127.0.0.1";
      };

      permissions = [
        {
          actor = domain;
          services = [
            {
              service = "*";
              level = "commands";
            }
          ];
        }
        {
          actor = "@js0ny:${domain}";
          services = [
            {
              service = "*";
              level = "admin";
            }
          ];
        }
      ];

      generic = {
        enabled = true;
        urlPrefix = "https://matrix.${domain}/webhook";
        outbound = false;
        allowJsTransformationFunctions = true;
      };

      listeners = [
        {
          port = ep.hookshot-webhooks.port;
          bindAddress = "127.0.0.1";
          resources = [ "webhooks" ];
        }
      ];
    };
  };

  nixdots.persist.system.directories = [
    {
      directory = "/var/lib/matrix-hookshot";
      mode = "0700";
    }
  ];

  services.nginx.virtualHosts."matrix.${domain}" = {
    locations."/webhook" = {
      proxyPass = "http://localhost:${webhookPortStr}";
      proxyWebsockets = true;
      extraConfig = /* nginx */ ''
        proxy_buffering off;
        proxy_cache off;
        proxy_read_timeout 1800;
        proxy_send_timeout 1800;
        proxy_connect_timeout 1800;
        add_header X-Accel-Buffering "no" always;
      '';
    };
  };
}
