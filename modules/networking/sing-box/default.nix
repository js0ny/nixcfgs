{
  flake.nixosModules.sing-box =
    { config, secrets, ... }:
    let
      port = 8443;
      realityServer = "www.apple.com";
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

      networking.firewall.allowedTCPPorts = [ port ];
    };
}
