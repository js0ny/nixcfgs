{ lib, config, ... }:
let
  ep = config.nixdefs.endpoints;
  portStr = ep.jellyfin.portStr;
  url = ep.jellyfin.domain;
in
{
  services.jellyfin = {
    enable = true;
    openFirewall = false;
  };

  services.nginx.virtualHosts = lib.mkIf (url != null) {
    ${url} = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:${portStr}";
        proxyWebsockets = true;
        extraConfig = /* nginx */ ''
          proxy_buffering off;
          proxy_request_buffering off;
          proxy_read_timeout 3600;
          proxy_send_timeout 3600;
        '';
      };
    };
  };
}
