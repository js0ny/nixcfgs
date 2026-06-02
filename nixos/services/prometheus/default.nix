{
  lib,
  config,
  myLib,
  ...
}:
let
  ep = config.nixdefs.endpoints;
  epSelf = ep.prometheus;
in
{
  imports = myLib.scanPaths ./.;
  services.prometheus = {
    enable = true;
    enableReload = true; # aka. watch config file change
    port = epSelf.port;
    listenAddress = epSelf.bindAddress;
    # webExternalUrl = epSelf.publicUrl;
  };

  nixdots.persist.system.directories = [ "/var/lib/${config.services.prometheus.stateDir}" ];
}
