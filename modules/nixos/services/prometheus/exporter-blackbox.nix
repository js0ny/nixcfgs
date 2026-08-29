{
  pkgs,
  config,
  ...
}:
let
  ep = config.nixdefs.endpoints;
  epSelf = ep.prometheus-exporter-blackbox;
in
{

  services.prometheus.exporters.blackbox = {
    enable = true;
    port = epSelf.port;
    listenAddress = epSelf.bindAddress;
    configFile = pkgs.writers.writeYAML "config.yaml" {
      modules = {
        https_2xx = {
          prober = "http";
          timeout = "15s";
          http = {
            fail_if_not_ssl = true;
            preferred_ip_protocol = "ip4";
            method = "GET";
            valid_status_codes = [
              200
              204
              206
              301
              302
              303
              304
              307
              308
            ];
            follow_redirects = false;
          };
        };
        tcp_connect = {
          prober = "tcp";
          timeout = "5s";
        };
      };
    };
  };
  services.prometheus.scrapeConfigs = [
    {
      job_name = "blackbox-http";
      metrics_path = "/probe";
      params.module = [ "https_2xx" ];

      static_configs = [
        {
          # TODO: Migrate to a non-consts field
          targets = config.nixdefs.consts.blackboxTargets;
        }
      ];

      relabel_configs = [
        {
          source_labels = [ "__address__" ];
          target_label = "__param_target";
        }
        {
          source_labels = [ "__param_target" ];
          target_label = "instance";
        }
        {
          source_labels = [ "__param_target" ];
          target_label = "target";
        }
        {
          target_label = "__address__";
          replacement = "${epSelf.bindAddress}:${epSelf.portStr}";
        }
      ];
    }
  ];

}
