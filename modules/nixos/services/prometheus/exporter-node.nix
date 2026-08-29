{
  lib,
  config,
  myLib,
  ...
}:
let
  ep = config.nixdefs.endpoints;
  epSelf = ep.prometheus-exporter-node;
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
            labels = {
              instance = config.networking.hostName;
            };
          }
        ];
      }
    ];
  };
}
