{ config, lib, ... }:
let
  epSelf = config.nixdefs.endpoints.ollama;
  port = epSelf.port;
  portStr = epSelf.portStr;
  url = epSelf.domain;
  bind = epSelf.bindAddress;
  cfg = config.nixdots.services.ollama;
  # nvidia = config.nixdots.machine.nvidia.mode;
in
lib.mkIf (cfg.enable) {
  services.ollama = {
    enable = true;
    host = bind;
    port = port;
    syncModels = lib.mkDefault true;
    loadModels = cfg.models;
  };
  services.nginx.virtualHosts = lib.mkIf (url != null) {
    ${url} = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${portStr}";
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
}
