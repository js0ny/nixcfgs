{
  flake.nixosModules.uptime-kuma =
    { lib, config, ... }:
    let
      ep = config.nixdefs.endpoints;
      epSelf = ep.uptime-kuma;
      portStr = epSelf.portStr;
      url = epSelf.domain;
    in
    {
      services.uptime-kuma = {
        enable = true;
        settings = {
          PORT = portStr;
          HOST = epSelf.bindAddress;
        };
      };
      services.nginx.virtualHosts = lib.mkIf (url != null) {
        "${url}" = {
          locations."/" = {
            proxyPass = "http://localhost:${portStr}";
          };
        }
        // config.nixdefs.consts.nginxWithCF;
      };
    };
}
