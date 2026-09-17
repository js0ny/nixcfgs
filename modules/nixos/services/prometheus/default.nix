{
  flake.nixosModules.prometheus =
    {
      secrets,
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
      imports = [
        ./alertmanager.nix
        ./exporter-blackbox.nix
      ];
      sops.secrets = {
        forgejo_metrics_token = {
          sopsFile = secrets + "/forgejo.yaml";
          owner = "prometheus";
          group = "prometheus";
        };
      };
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

      js0ny.persist.stores.state.directories = [ "/var/lib/${config.services.prometheus.stateDir}" ];
    };
}
