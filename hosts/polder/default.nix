{
  inputs,
  secrets,
  ...
}:
{
  imports = [
    inputs.self.nixosModules.server
    # Host-specific configs
    ./hardware-configuration.nix
    ./vars.nix

    # ./services/actual.nix
    # ../../nixos/services/affine.nix
    # keep-sorted start

    ./static/flux.nix
    inputs.self.nixosModules.authelia
    inputs.self.nixosModules.bentopdf
    inputs.self.nixosModules.cloudflare
    inputs.self.nixosModules.code-server
    inputs.self.nixosModules.fail2ban
    inputs.self.nixosModules.fast-note-sync
    inputs.self.nixosModules.forgejo
    inputs.self.nixosModules.forgejo-runner
    inputs.self.nixosModules.garage
    inputs.self.nixosModules.gluetun
    inputs.self.nixosModules.grafana
    inputs.self.nixosModules.hermes-agent
    inputs.self.nixosModules.jellyfin
    inputs.self.nixosModules.karakeep
    inputs.self.nixosModules.librechat
    inputs.self.nixosModules.litellm
    inputs.self.nixosModules.lobehub
    inputs.self.nixosModules.miniflux
    inputs.self.nixosModules.mongodb
    inputs.self.nixosModules.navidrome
    inputs.self.nixosModules.nextcloud
    inputs.self.nixosModules.opengist
    inputs.self.nixosModules.paperless
    inputs.self.nixosModules.postgresql
    inputs.self.nixosModules.prometheus
    inputs.self.nixosModules.radicale
    inputs.self.nixosModules.rclone
    inputs.self.nixosModules.rsshub
    inputs.self.nixosModules.searxng
    # inputs.self.nixosModules.core
    inputs.self.nixosModules.starship
    inputs.self.nixosModules.sub2api
    inputs.self.nixosModules.tailscale
    inputs.self.nixosModules.telegram-inline-llm-bot
    inputs.self.nixosModules.uptime-kuma
    inputs.self.nixosModules.valkey
    inputs.self.nixosModules.vikunja
    # keep-sorted end
  ];

  home-manager = {
    users."js0ny" = import ./home.nix;
  };

  sops.secrets = {
    rclone = {
      key = "data";
      sopsFile = secrets + /files/rclone.yaml;
      path = "/var/lib/rclone/rclone.conf";
      owner = "root";
    };
  };

  users.mutableUsers = false;
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "/dev/sda" ];
  boot.kernelParams = [
    "console=ttyS0,115200n8"
    "console=tty0"
  ];
  boot.loader.grub.useOSProber = false;
  networking = {
    usePredictableInterfaceNames = false;
    interfaces.eth0.ipv4.addresses = [
      {
        address = "158.220.98.103";
        prefixLength = 20;
      }
    ];
    defaultGateway = {
      address = "158.220.96.1";
      interface = "eth0";
    };
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
      "2606:4700:4700::1111"
      "2001:4860:4860::8888"
    ];
    firewall = {
      enable = true;
      allowedTCPPorts = [
        80
        443
      ];
    };
  };

  nixdefs = {
    mcp.enable = true;
    llm.enable = true;
  };

  security.sudo-rs.wheelNeedsPassword = false;

  system.stateVersion = "25.05";
}
