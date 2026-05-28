{
  config,
  lib,
  secrets,
  ...
}:
let
  ep = config.nixdefs.endpoints;
  epSelf = ep.coturn;
  portStr = epSelf.portStr;
  url = epSelf.domain;
in
{
  sops.secrets = {
    coturn_matrix_secret = {
      sopsFile = secrets + /matrix.yaml;
      owner = config.systemd.services.coturn.serviceConfig.User;
    };
    tuwunel_turn_secret = {
      sopsFile = secrets + /matrix.yaml;
      key = "coturn_matrix_secret";
      owner = config.services.matrix-tuwunel.user;
    };
  };
  services.coturn = {
    enable = true;
    use-auth-secret = true;
    static-auth-secret-file = config.sops.secrets.coturn_matrix_secret.path;
    realm = url;
    min-port = 49000;
    max-port = 50000;
  };

  services.matrix-tuwunel.settings.global = {
    turn_uris = [
      "turns:${url}:${portStr}?transport=udp"
      "turns:${url}:${portStr}?transport=tcp"
    ];
    turn_secret_file = config.sops.secrets.tuwunel_turn_secret.path;
  };

  networking.firewall = {
    allowedTCPPorts = [ epSelf.port ];
    allowedUDPPorts = [ epSelf.port ];
    allowedUDPPortRanges = [
      {
        from = 49000;
        to = 50000;
      }
    ];
  };
}
