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
        checkConfig = "syntax-only";
        # webExternalUrl = epSelf.publicUrl;
        scrapeConfigs = [
          {
            job_name = "authelia";
            static_configs = [
              { targets = [ "${epAutheliaMetrics.bindAddress}:${epAutheliaMetrics.portStr}" ]; }
            ];
          }
          {
            job_name = "forgejo";
            scheme = "https";
            static_configs = [
              { targets = [ ep.forgejo.domain ]; }
            ];
            authorization = {
              type = "Bearer";
              credentials_file = config.sops.secrets.forgejo_metrics_token.path;
            };
          }
        ];
      };

      nixdots.persist.system.directories = [ "/var/lib/${config.services.prometheus.stateDir}" ];
    };
}
