# Tuwunel does not yet implement MSC4140, so MatrixRTC remains experimental.
{
  config,
  lib,
  ...
}:
let
  ep = config.nixdefs.endpoints;
  domain = "js0ny.net";
  matrixDomain = ep.matrix.domain;
  livekitPort = ep.livekit.port;
  livekitJwtPort = ep.livekit-jwt.port;
  livekitPath = "/livekit/sfu";
  livekitUrl = "wss://${matrixDomain}${livekitPath}";
  livekitJwtPath = "/livekit/jwt";
  rtcPortRange = {
    from = 50100;
    to = 50200;
  };
in
{

  # Reuse the existing random media secret to avoid a separate secret migration for this experiment.
  sops.templates."livekit-keys".content = /* yaml */ ''
    matrix: ${config.sops.placeholder.coturn_matrix_secret}
  '';

  services.livekit = {
    enable = true;
    keyFile = config.sops.templates."livekit-keys".path;
    # https://github.com/livekit/livekit/blob/master/config-sample.yaml
    settings = {
      port = livekitPort;
      bind_addresses = [ "127.0.0.1" ];
      rtc = {
        tcp_port = 7881;
        port_range_start = rtcPortRange.from;
        port_range_end = rtcPortRange.to;
        use_external_ip = false;
        node_ip = config.nixdots.server.ip;
      };
      room.auto_create = false;
    };
  };

  services.lk-jwt-service = {
    enable = true;
    inherit livekitUrl;
    keyFile = config.sops.templates."livekit-keys".path;
    port = livekitJwtPort;
  };

  systemd.services.lk-jwt-service = {
    requires = [ "livekit.service" ];
    after = [
      "livekit.service"
      "tuwunel.service"
    ];
    environment = {
      LIVEKIT_FULL_ACCESS_HOMESERVERS = domain;
      LIVEKIT_JWT_BIND = lib.mkForce "127.0.0.1:${toString livekitJwtPort}";
    };
  };

  services.matrix-tuwunel.settings.global.well_known = {
    client = "https://${matrixDomain}";
    livekit_url = "https://${matrixDomain}${livekitJwtPath}";
  };

  services.nginx.virtualHosts.${matrixDomain}.locations = {
    "^~ ${livekitJwtPath}/".proxyPass = "http://127.0.0.1:${toString livekitJwtPort}/";
    "^~ ${livekitPath}/" = {
      proxyPass = "http://127.0.0.1:${toString livekitPort}/";
      proxyWebsockets = true;
      extraConfig = /* nginx */ ''
        proxy_buffering off;
        proxy_read_timeout 120s;
        proxy_send_timeout 120s;
      '';
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 7881 ];
    allowedUDPPortRanges = [ rtcPortRange ];
  };
}
