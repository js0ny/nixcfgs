{
  flake.nixosModules.ollama =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      epSelf = config.nixdefs.endpoints.ollama;
      cfg = config.services.ollama;
      proxyHost =
        if cfg.host == "0.0.0.0" then
          "127.0.0.1"
        else if cfg.host == "::" then
          "[::1]"
        else if lib.hasInfix ":" cfg.host then
          "[${cfg.host}]"
        else
          cfg.host;
    in
    {
      services.ollama = {
        enable = lib.mkDefault true;
        host = lib.mkDefault epSelf.bindAddress;
        port = lib.mkDefault epSelf.port;
        package = lib.mkIf (config.js0ny.hardware.gpu.driver == "nvidia") (lib.mkDefault pkgs.ollama-cuda);
        syncModels = lib.mkDefault false;
      };
      services.nginx.virtualHosts = lib.mkIf (cfg.enable && epSelf.domain != null) {
        ${epSelf.domain} = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://${proxyHost}:${toString cfg.port}";
            proxyWebsockets = true;
            extraConfig = /* nginx */ ''
              proxy_buffering off;
              proxy_request_buffering off;
              proxy_read_timeout 3600;
              proxy_send_timeout 3600;
            '';
          };
        };
      };
    };
}
