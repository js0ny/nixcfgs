{
  config,
  secrets,
  ...
}:
let
  port = 8443;
  realityServer = "www.apple.com";
  dnsServer = "1.1.1.1";
  sopsFile = secrets + "/sing-box.yaml";
in
{
  sops.secrets = {
    singbox_js0ny_uuid = { inherit sopsFile; };
    singbox_reality_private_key = { inherit sopsFile; };
    singbox_reality_short_id = { inherit sopsFile; };
  };

  services.sing-box = {
    enable = true;
    # https://sing-box.sagernet.org/configuration/
    settings = {
      dns.servers = [
        {
          type = "udp";
          tag = "direct-dns";
          server = dnsServer;
        }
      ];
      inbounds = [
        {
          type = "vless";
          tag = "vless-in";
          listen = "::";
          listen_port = port;
          users = [
            {
              name = "default";
              uuid._secret = config.sops.secrets.singbox_js0ny_uuid.path;
              flow = "xtls-rprx-vision";
            }
          ];
          tls = {
            enabled = true;
            # server_name = realityServer;
            reality = {
              enabled = true;
              handshake = {
                server = realityServer;
                server_port = 443;
                domain_resolver = "direct-dns";
              };
              private_key._secret = config.sops.secrets.singbox_reality_private_key.path;
              short_id = [
                { _secret = config.sops.secrets.singbox_reality_short_id.path; }
              ];
            };
          };
        }
      ];
    };
  };

  systemd.services.sing-box.serviceConfig = {
    # Prevent proxy traffic from reaching this host, private networks, or IPv6.
    IPAddressDeny = [
      "localhost"
      "link-local"
      "multicast"
      "10.0.0.0/8"
      "100.64.0.0/10"
      "172.16.0.0/12"
      "192.168.0.0/16"
      "::/0"
    ];
  };

  networking.firewall.allowedTCPPorts = [ port ];
}
