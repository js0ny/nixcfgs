{
  inputs,
  ...
}:
let
  mod = inputs.self.nixosModules;
in
{
  system.stateVersion = "26.05";

  imports = [
    ./disko.nix
    ./vars.nix

    inputs.srvos.nixosModules.hardware-hetzner-cloud

    mod.server

    mod.cloudflare
    mod.fail2ban
    mod.prometheus-node

    mod.matrix-server
    mod.bentopdf
  ];

  home-manager.users."js0ny" = import ./home.nix;

  boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/sda";
  boot.kernelParams = [
    "console=ttyS0,115200n8"
    "console=tty0"
  ];
  boot.loader.grub.useOSProber = false;
  boot.loader.grub.efiSupport = false;

  networking.firewall.enable = true;

  systemd.network.networks."10-wan" = {
    matchConfig.Name = "enp1s0";
    networkConfig.DHCP = "ipv4";
  };
}
