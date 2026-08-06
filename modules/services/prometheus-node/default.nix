{
  flake.nixosModules.prometheus-node =
    {
      lib,
      config,
      myLib,
      ...
    }:
    let
      ep = config.nixdefs.endpoints;
      epProm = ep.prometheus;
      epSelf = ep.prometheus-exporter-node;
    in
    {
      services.prometheus = {
        enable = true;
        enableReload = true; # aka. watch config file change
        checkConfig = "syntax-only";
        port = epProm.port;
        listenAddress = epProm.bindAddress;
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
    };
}
