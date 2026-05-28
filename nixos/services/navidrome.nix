{ config, ... }:
let
  ep = config.nixdefs.endpoints;
  ipAddr = ep.navidrome.bindAddress;
  port = ep.navidrome.port;
  url = ep.navidrome.domain;
in
{
  services.navidrome = {
    enable = true;
    settings = {
      Address = ipAddr;
      Port = port;
      MusicFolder = "/srv/Music";
      DefaultTheme = "AMusic";
      EnableSharing = true;
      BaseUrl = "https://${url}";
    };
  };

  services.nginx.virtualHosts."${url}" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://localhost:${toString port}";
    };
  };
  systemd.services.navidrome = {
    after = [ "rclone-pcloud-mount.target" ];
  };
}
