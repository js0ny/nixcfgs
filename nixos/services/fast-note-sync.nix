{ config, lib, ... }:
let
  version = "3.1.2";

  ep = config.nixdefs.endpoints;
  epSelf = ep.fast-note-sync;
  url = epSelf.domain;
  port = epSelf.port;
  portStr = epSelf.portStr;
  iportStr = "9000";
  ipAddr = epSelf.bindAddress;
  stateDir = "/var/lib/fast-note-sync";
  username = config.nixdots.user.name;
  fileopt = "0755 ${username} users -";
in
{
  virtualisation.oci-containers.containers."fast-note-sync-service" = {
    image = "haierkeys/fast-note-sync-service:${version}";
    ports = [
      "${ipAddr}:${portStr}:${iportStr}"
    ];
    volumes = [
      "${stateDir}/storage:/fast-note-sync/storage"
      "${stateDir}/config:/fast-note-sync/config"
    ];
  };

  systemd.tmpfiles.rules = [
    "d ${stateDir}/storage ${fileopt}"
    "d ${stateDir}/config ${fileopt}"
  ];

  services.nginx.virtualHosts = lib.mkIf (url != null) {
    "${url}" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:${toString port}";
        proxyWebsockets = true;
      };
    };
  };
}
