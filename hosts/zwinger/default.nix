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
  system.stateVersion = "26.05";

  imports = [
    ./disko.nix
    ./vars.nix

    inputs.srvos.nixosModules.hardware-hetzner-cloud

    mod.server

    mod.fail2ban
    mod.prometheus-node

    mod.matrix-server
    mod.bentopdf
  ];

  # https://matrix-construct.github.io/tuwunel/configuration/examples.html
  services.matrix-tuwunel.settings.global.rocksdb_allow_fallocate = false;

  # Public IPv4 of this host, advertised to WebRTC clients.
  services.livekit.settings.rtc.node_ip = "178.104.159.210";

  home-manager.users."js0ny" = import ./home.nix;

  boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/sda";
  boot.kernelParams = [
    "console=ttyS0,115200n8"
    "console=tty0"
  ];
  boot.loader.grub.useOSProber = false;
  boot.loader.grub.efiSupport = false;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      endpoints.http.port
      endpoints.https.port
    ];
  };

  systemd.network.networks."10-wan" = {
    matchConfig.Name = "enp1s0";
    networkConfig.DHCP = "ipv4";
  };
}
