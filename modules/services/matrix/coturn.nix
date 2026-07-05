{
  config,
  lib,
  secrets,
  ...
}:
let
  ep = config.nixdefs.endpoints;
  epSelf = ep.coturn;
  url = epSelf.domain;
  turnPort = 3478;
  turnsPort = 5349;
in
{
  sops.secrets = {
    coturn_matrix_secret = {
      sopsFile = secrets + /matrix.yaml;
      owner = config.systemd.services.coturn.serviceConfig.User;
      group = config.systemd.services.coturn.serviceConfig.Group;
    };
    tuwunel_turn_secret = {
      sopsFile = secrets + /matrix.yaml;
      key = "coturn_matrix_secret";
      owner = config.services.matrix-tuwunel.user;
      group = config.services.matrix-tuwunel.group;
    };
  };
  services.coturn = {
    enable = true;
    no-cli = true;
    no-tcp-relay = true;
    listening-port = turnPort;
    tls-listening-port = turnsPort;
    use-auth-secret = true;
    static-auth-secret-file = config.sops.secrets.coturn_matrix_secret.path;
    realm = url;
    cert = "${config.security.acme.certs.${url}.directory}/full.pem";
    pkey = "${config.security.acme.certs.${url}.directory}/key.pem";
    min-port = 49000;
    max-port = 50000;
    extraConfig = /* ini */ ''
      no-multicast-peers
      denied-peer-ip=0.0.0.0-0.255.255.255
      denied-peer-ip=10.0.0.0-10.255.255.255
      denied-peer-ip=100.64.0.0-100.127.255.255
      denied-peer-ip=127.0.0.0-127.255.255.255
      denied-peer-ip=169.254.0.0-169.254.255.255
      denied-peer-ip=172.16.0.0-172.31.255.255
      denied-peer-ip=192.0.0.0-192.0.0.255
      denied-peer-ip=192.0.2.0-192.0.2.255
      denied-peer-ip=192.88.99.0-192.88.99.255
      denied-peer-ip=192.168.0.0-192.168.255.255
      denied-peer-ip=198.18.0.0-198.19.255.255
      denied-peer-ip=198.51.100.0-198.51.100.255
      denied-peer-ip=203.0.113.0-203.0.113.255
      denied-peer-ip=240.0.0.0-255.255.255.255
      denied-peer-ip=::1
      denied-peer-ip=64:ff9b::-64:ff9b::ffff:ffff
      denied-peer-ip=::ffff:0.0.0.0-::ffff:255.255.255.255
      denied-peer-ip=100::-100::ffff:ffff:ffff:ffff
      denied-peer-ip=2001::-2001:1ff:ffff:ffff:ffff:ffff:ffff:ffff
      denied-peer-ip=2002::-2002:ffff:ffff:ffff:ffff:ffff:ffff:ffff
      denied-peer-ip=fc00::-fdff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
      denied-peer-ip=fe80::-febf:ffff:ffff:ffff:ffff:ffff:ffff:ffff
    '';
  };

  services.matrix-tuwunel.settings.global = {
    turn_uris = [
      "turn:${url}:${toString turnPort}?transport=udp"
      "turn:${url}:${toString turnPort}?transport=tcp"
      "turns:${url}:${toString turnsPort}?transport=tcp"
    ];
    turn_secret_file = config.sops.secrets.tuwunel_turn_secret.path;
  };

  security.acme.certs.${url} = {
    webroot = "/var/lib/acme/acme-challenge";
    postRun = "systemctl restart coturn.service";
    group = config.systemd.services.coturn.serviceConfig.Group;
  };

  services.nginx.virtualHosts.${url} = {
    locations."/.well-known/acme-challenge/".root = "/var/lib/acme/acme-challenge";
    locations."/".return = "404";
  };

  networking.firewall =
    let
      range =
        with config.services.coturn;
        lib.singleton {
          from = min-port;
          to = max-port;
        };
    in
    {
      allowedTCPPorts = [
        turnPort
        turnsPort
      ];
      allowedUDPPorts = [
        turnPort
        turnsPort
      ];
      allowedUDPPortRanges = range;
    };
}
