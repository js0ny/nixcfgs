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
    mod.cloudflare
    mod.fail2ban
    mod.starship
    mod.fish
    mod.nix-index-database
    mod.code-server
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
