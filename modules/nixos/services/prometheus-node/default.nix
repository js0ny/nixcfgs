{
  flake.nixosModules.prometheus-node =
    { config, ... }:
    let
      ep = config.nixdefs.endpoints;
      epSelf = ep.prometheus-exporter-node;
    in
    {
      services.prometheus = {
        enable = false;
        exporters.node = {
          enable = true;
          enabledCollectors = [ "systemd" ];
          port = epSelf.port;
          listenAddress = epSelf.bindAddress;
        };
      };
    };
}
