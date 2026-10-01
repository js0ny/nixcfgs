{ config, lib, ... }:
let
  ep = config.nixdefs.endpoints;
  epSelf = ep.prometheus-exporter-node;
  hosts = lib.filterAttrs (_: host: host.prometheus.node-exporter or false) (
    (import ../../../../definitions/hosts.nix).nixos
  );
  hostsWithoutCurrent = removeAttrs hosts [ config.networking.hostName ];
  mkStaticConfig = name: host: {
    targets = [ "${host.tailscale.ipv4}:${epSelf.portStr}" ];
    labels.instance = name;
  };
in
{
  services.prometheus = {
    exporters.node = {
      enable = true;
      enabledCollectors = [ "systemd" ];
      port = epSelf.port;
      listenAddress = epSelf.bindAddress;
    };
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = [ "127.0.0.1:${epSelf.portStr}" ];
            labels.instance = config.networking.hostName;
          }
        ]
        ++ lib.mapAttrsToList mkStaticConfig hostsWithoutCurrent;
      }
    ];
  };
}
