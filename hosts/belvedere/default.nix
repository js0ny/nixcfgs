{
  inputs,
  ...
}:
let
  mod = inputs.self.nixosModules;
in
{
  system.stateVersion = "26.11";

  imports = [
    ./disko.nix
    ./vars.nix
    ./hardware-configuration.nix

    mod.server
    # keep-sorted start
    mod.cloudflare
    mod.code-server
    mod.fail2ban
    mod.fish
    mod.forgejo
    mod.hermes-agent
    mod.immich
    mod.jellyfin
    mod.nextcloud
    mod.nix-index-database
    mod.prometheus-node
    mod.rclone
    mod.sing-box
    mod.starship
    # keep-sorted end
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
    firewall = {
      enable = true;
    };
  };

  systemd.network.networks."10-wan" = {
    matchConfig.MACAddress = "da:cc:d5:81:92:7b";
    networkConfig = {
      DHCP = "ipv4";
      IPv6AcceptRA = true;
    };
  };
}
