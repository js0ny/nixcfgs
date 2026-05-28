{ lib, config, ... }:
let
  ep = config.nixdefs.endpoints;
  url = ep.forgejo.domain;
  port = ep.forgejo.port;
  portStr = ep.forgejo.portStr;
in
{
  services.forgejo = {
    enable = true;
    settings = {
      server = {
        HTTP_PORT = port;
      }
      // lib.optionalAttrs (url != null) {
        ROOT_URL = "https://${url}";
      };
      service = {
        DISABLE_REGISTRATION = true;
      };
    };
    lfs.enable = true;
  };
  services.nginx.virtualHosts = lib.mkIf (url != null) {
    "${url}" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:${portStr}";
      };
    };
  };
  catppuccin = {
    forgejo.enable = true;
    accent = "pink";
    flavor = "mocha";
  };

}
