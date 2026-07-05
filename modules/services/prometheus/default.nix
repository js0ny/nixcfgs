{
  flake.nixosModules.prometheus =
    {
      lib,
      config,
      myLib,
      ...
    }:
    let
      ep = config.nixdefs.endpoints;
      epSelf = ep.prometheus;
      epAutheliaMetrics = ep.authelia-metrics;
    in
    {
      imports = myLib.scanPaths ./.;
      services.prometheus = {
        enable = true;
        enableReload = true; # aka. watch config file change
        port = epSelf.port;
        listenAddress = epSelf.bindAddress;
        # webExternalUrl = epSelf.publicUrl;
        scrapeConfigs = [
          {
            job_name = "authelia";
            static_configs = [
              { targets = [ "${epAutheliaMetrics.bindAddress}:${epAutheliaMetrics.portStr}" ]; }
            ];
          }
        ];
      };

      nixdots.persist.system.directories = [ "/var/lib/${config.services.prometheus.stateDir}" ];
    };
}
