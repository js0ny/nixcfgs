{
  flake.nixosModules.gluetun =
    ### Gluetun + qBittorrent: torrenting via VPN tunnel
    ### Extra Settings:
    ## Extra Settings for qBittorrent
    # [Preferences]
    # WebUI\ServerDomains=*
    # WebUI\CSRFProtection=false
    # WebUI\HostHeaderValidation=false
    ### Checking VPN Leak:
    # sudo podman exec -it qbittorrent curl ifconfig.me
    # Put the return value to: https://www.iplocation.net/
    # Or use
    # https://ipleak.net/
    # Torrent Address detection -> Copy the torrent link -> Go to qbittorrent WebUI -> Download
    # Then the ipleak.net should show the VPN IP address
    {
      secrets,
      config,
      ...
    }:
    let
      ip = config.nixdots.services.tailscale.ip;
      qbStateDir = "/var/lib/qbittorrent";
      qbConfigPath = "${qbStateDir}/config";
      tag = "v3.41";
      qbTag = "latest";
    in
    {
      sops.secrets = {
        wg_pvpn_nl = {
          sopsFile = secrets + /wireguard.yaml;
        };
      };
      sops.templates."gluetun.env".content = /* bash */ ''
        WIREGUARD_PRIVATE_KEY=${config.sops.placeholder.wg_pvpn_nl}
      '';
      virtualisation.oci-containers = {
        containers = {
          # 1. VPN 容器 (Gluetun)
          gluetun = {
            image = "qmcgaw/gluetun:${tag}";
            capabilities = {
              "NET_ADMIN" = true;
            };
            environment = {
              VPN_SERVICE_PROVIDER = "protonvpn";
              VPN_TYPE = "wireguard";
              SERVER_COUNTRIES = "Netherlands";
              FIREWALL_VPN_INPUT_PORTS = "8080";
            };
            environmentFiles = [ config.sops.templates."gluetun.env".path ];
            ports = [
              "${ip}:8080:8080"
            ];
            extraOptions = [
              "--device=/dev/net/tun:/dev/net/tun"
              "--cap-add=NET_ADMIN"
            ];
          };

          qbittorrent = {
            image = "lscr.io/linuxserver/qbittorrent:${qbTag}";
            environment = {
              PUID = "1000";
              PGID = "100";
              TZ = "Etc/UTC";
              WEBUI_PORT = "8080";
              DOCKER_MODS = "ghcr.io/vuetorrent/vuetorrent-lsio-mod:latest";
            };
            volumes = [
              "${qbConfigPath}:/config"
              "/var/lib/qbittorrent/downloads:/downloads"
            ];
            extraOptions = [ "--network=container:gluetun" ];
            dependsOn = [ "gluetun" ];
          };
        };
      };

      systemd.tmpfiles.rules = [
        "d /var/lib/qbittorrent/config 0755 js0ny users -"
        "d /var/lib/qbittorrent/downloads 0755 js0ny users -"
      ];

      nixdots.persist.system.directories = [ qbStateDir ];
    };
}
