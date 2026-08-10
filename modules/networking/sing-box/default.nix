{
  flake.nixosModules.sing-box =
    {
      config,
      pkgs,
      secrets,
      ...
    }:
    let
      port = 8443;
      realityServer = "www.apple.com";
      resolvConf = pkgs.writeText "sing-box-resolv.conf" (
        builtins.concatStringsSep "\n" (
          map (nameserver: "nameserver ${nameserver}") config.networking.nameservers
        )
        + "\n"
      );
      sopsFile = secrets + /sing-box.yaml;
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
        # The systemd-resolved stub is blocked with the rest of localhost.
        BindReadOnlyPaths = [ "${resolvConf}:/etc/resolv.conf" ];
        # Prevent proxy traffic from reaching localhost, LANs, Tailscale, or IPv6 ULAs.
        IPAddressDeny = [
          "localhost"
          "link-local"
          "multicast"
          "10.0.0.0/8"
          "100.64.0.0/10"
          "172.16.0.0/12"
          "192.168.0.0/16"
          "fc00::/7"
        ];
      };

      networking.firewall.allowedTCPPorts = [ port ];
    };
}
