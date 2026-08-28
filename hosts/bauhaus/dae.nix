{ config, secrets, ... }:
let
  port = toString 8443;
  sopsFile = secrets + "/sing-box.yaml";
in
{
  sops.secrets = {
    singbox_js0ny_uuid = { inherit sopsFile; };
    singbox_reality_private_key = { inherit sopsFile; };
    singbox_reality_public_key = { inherit sopsFile; };
    singbox_reality_short_id = { inherit sopsFile; };
  };

  sops.templates."dae.dae".content = /* dae */ ''
    global {
      wan_interface: auto
      auto_config_kernel_parameter: true
      dial_mode: domain+
    }

    # Do not set `sni`: dae + REALITY fails with
    # "REALITY: processed invalid connection" when explicitly set.
    node {
      vless: 'vless://${config.sops.placeholder.singbox_js0ny_uuid}@${config.secrets.plain.belvedere.ipv4}:${port}?encryption=none&flow=xtls-rprx-vision&security=reality&fp=chrome&pbk=${config.sops.placeholder.singbox_reality_public_key}&sid=${config.sops.placeholder.singbox_reality_short_id}&type=tcp#belvedere'
    }

    group {
      proxy {
        filter: name(vless)
        policy: fixed(0)
      }
    }

    routing {
      pname(NetworkManager) -> direct

      # tailnet
      pname(tailscaled) -> must_direct
      l4proto(udp) && dport(3478) -> must_direct
      l4proto(udp) && sport(41641) -> must_direct
      dip(100.64.0.0/10, 'fd7a:115c:a1e0::/48') -> must_direct

      dip(224.0.0.0/3, 'ff00::/8') -> direct
      dip(geoip:private) -> direct

      # Disable HTTP/3 on vless
      l4proto(udp) && dport(443) -> block

      l4proto(udp) -> direct


      domain(
        suffix: ac.uk
        suffix: org.uk
      ) -> direct

      # Blocked by British Online Safety Act
      domain(
        suffix: or.cz, # repo.or.cz
        suffix: civitai.com,
        suffix: imgur.com
      ) -> proxy

      fallback: proxy
    }
  '';

  services.dae = {
    enable = true;
    configFile = config.sops.templates."dae.dae".path;
    openFirewall = {
      enable = false;
      port = 12345;
    };
  };
}
