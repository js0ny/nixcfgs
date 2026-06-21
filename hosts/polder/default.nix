{
  pkgs,
  lib,
  config,
  inputs,
  nixcfgs,
  myLib,
  secrets,
  ...
}:
{
  imports = [
    ../../nixos/server
    # Host-specific configs
    ./hardware-configuration.nix
    ./vars.nix

    # ./services/actual.nix
    # ../../nixos/services/affine.nix
    # keep-sorted start
    ../../nixos/services/authelia
    ../../nixos/services/bentopdf.nix
    ../../nixos/services/cloudflare.nix
    ../../nixos/services/fail2ban.nix
    ../../nixos/services/fast-note-sync.nix
    ../../nixos/services/forgejo-runner.nix
    ../../nixos/services/forgejo.nix
    ../../nixos/services/garage.nix
    ../../nixos/services/gluetun.nix
    ../../nixos/services/grafana.nix
    ../../nixos/services/hermes-agent
    ../../nixos/services/jellyfin
    ../../nixos/services/karakeep.nix
    ../../nixos/services/librechat
    ../../nixos/services/litellm
    ../../nixos/services/lobehub.nix
    ../../nixos/services/miniflux.nix
    ../../nixos/services/mongodb.nix
    ../../nixos/services/navidrome.nix
    ../../nixos/services/nextcloud.nix
    ../../nixos/services/opengist.nix
    ../../nixos/services/paperless.nix
    ../../nixos/services/postgresql.nix
    ../../nixos/services/prometheus
    ../../nixos/services/radicale.nix
    ../../nixos/services/rclone.nix
    ../../nixos/services/rsshub.nix
    ../../nixos/services/searxng.nix
    ../../nixos/services/sub2api.nix
    ../../nixos/services/telegram-inline-llm-bot.nix
    ../../nixos/services/uptime-kuma.nix
    ../../nixos/services/valkey.nix
    ../../nixos/services/vikunja.nix
    ./static/flux.nix
    # keep-sorted end
  ];

  home-manager = {
    extraSpecialArgs = {
      inherit
        inputs
        nixcfgs
        myLib
        secrets
        ;
    };
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

  nixpkgs.config.allowUnfree = true;
  security.sudo-rs.wheelNeedsPassword = false;

  system.stateVersion = "25.05";
}
