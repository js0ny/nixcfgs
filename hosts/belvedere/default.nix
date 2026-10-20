{
  inputs,
  config,
  ...
}:
let
  mod = inputs.self.nixosModules;
  endpoints = config.nixdefs.endpoints;
in
{
  system.stateVersion = "26.11";

  imports = [
    ./disko.nix
    ./vars.nix
    ./hardware-configuration.nix

    mod.server
    # keep-sorted start
    ../../migrated/nixos/server-apps/fail2ban.nix
    ../../migrated/nixos/web-apps/fast-note-sync.nix
    ../../migrated/nixos/web-apps/gluetun.nix
    ../../migrated/nixos/web-apps/navidrome.nix
    ../../migrated/nixos/web-apps/pdf2zh.nix
    mod.fish
    mod.forgejo
    mod.grafana
    mod.hermes-agent
    mod.idp
    mod.immich
    mod.jellyfin
    mod.karakeep
    mod.miniflux
    mod.nix-index-database
    mod.opengist
    mod.papra
    mod.prometheus
    mod.radicale
    mod.rclone
    mod.rsshub
    mod.searxng
    mod.sing-box
    # keep-sorted end
    mod.starship
  ];

  home-manager.users."js0ny" = import ./home.nix;

  boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/vda";
  boot.kernelParams = [
    "console=ttyS0,115200n8"
    "console=tty0"
  ];
  boot.loader.grub.useOSProber = false;
  boot.loader.grub.efiSupport = false;

  networking = {
    useNetworkd = true;
    useDHCP = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        endpoints.http.port
        endpoints.https.port
      ];
      allowedUDPPorts = [ 443 ];
    };
  };

  systemd.network.networks."10-wan" = {
    matchConfig.MACAddress = "da:cc:d5:81:92:7b";
    address = [ "89.58.62.165/22" ];
    networkConfig = {
      DHCP = "no";
      IPv6AcceptRA = true;
    };
    routes = [
      {
        Gateway = "89.58.60.1";
        GatewayOnLink = true;
      }
    ];
  };

  js0ny.persist.stores.state.directories = [ "/var/lib/postgresql" ];
}
