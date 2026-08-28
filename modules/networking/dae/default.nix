{
  flake.nixosModules.dae =
    {
      config,
      secrets,
      pkgsStable,
      ...
    }:
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
        dae_subscription_dn = {
          sopsFile = secrets + "/dae.yaml";
        };
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
          belvedere: 'vless://${config.sops.placeholder.singbox_js0ny_uuid}@${config.secrets.plain.belvedere.ipv4}:${port}?encryption=none&flow=xtls-rprx-vision&security=reality&fp=chrome&pbk=${config.sops.placeholder.singbox_reality_public_key}&sid=${config.sops.placeholder.singbox_reality_short_id}&type=tcp#belvedere'
        }

        subscription {
          dn: '${config.sops.placeholder.dae_subscription_dn}'
        }

        group {
          proxy {
            # Only use nodes from the dn subscription.
            # belvedere therefore remains available in the global node pool,
            # but will not be selected by this group.
            filter: subtag(dn)

            # Automatically select according to moving-average latency.
            policy: min_moving_avg
          }
          gb {
            filter: subtag(dn) && name(regex: 'UK|英国')
            policy: min_moving_avg
          }
          jp {
            filter: subtag(dn) && name(regex: 'JP|日本')
            policy: min_moving_avg
          }
          claude {
            filter: subtag(dn) && name(regex: '美国LA')
            policy: min_moving_avg
          }
        }

        routing {
          pname(NetworkManager) -> direct

          # Tailscale
          pname(tailscaled) -> must_direct
          l4proto(udp) && dport(3478) -> must_direct
          l4proto(udp) && sport(41641) -> must_direct
          dip(100.64.0.0/10, 'fd7a:115c:a1e0::/48') -> must_direct

          # LAN / multicast
          dip(224.0.0.0/3, 'ff00::/8') -> direct
          dip(geoip:private) -> direct

          # Mainland China
          domain(geosite:cn) -> direct
          dip(geoip:cn) -> direct

          # Disable HTTP/3 / QUIC.
          # NOTE: if you later want application UDP traffic to use proxy,
          # revisit the UDP rules below.
          l4proto(udp) && dport(443) -> block

          # Keep current behavior: all other application UDP traffic goes direct.
          l4proto(udp) -> direct

          domain(
            suffix: ac.uk,
            suffix: org.uk,
            suffix: gov.uk
          ) -> gb

          domain(
            suffix: chatgpt.com,
            suffix: openai.com,
            suffix: oaistatic.com,
            suffix: oaiusercontent.com
          ) -> jp

          domain(
            full: cdn.usefathom.com,
            suffix: claude.ai,
            suffix: anthropic.com
          ) -> claude

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
        package = pkgsStable.dae;
        configFile = config.sops.templates."dae.dae".path;
        openFirewall = {
          enable = false;
          port = 12345;
        };
      };
    };
}
