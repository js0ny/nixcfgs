{
  pkgs,
  config,
  inputs,
  nixcfgs,
  myLib,
  secrets,
  ...
}:
{
  system.stateVersion = "26.05";

  imports = [
    ./disko.nix
    ./vars.nix

    ../../nixos
    inputs.self.nixosModules.server
    inputs.srvos.nixosModules.hardware-hetzner-cloud
    inputs.self.nixosModules.cloudflare
    inputs.self.nixosModules.matrix
    inputs.self.nixosModules.fail2ban
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
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

  boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/sda";
  boot.kernelParams = [
    "console=ttyS0,115200n8"
    "console=tty0"
  ];
  boot.loader.grub.useOSProber = false;
  boot.loader.grub.efiSupport = false;

  security.sudo.enable = false;
  security.sudo-rs.enable = true;
  security.sudo-rs.wheelNeedsPassword = false;

  networking = {
    firewall = {
      enable = true;
    };
  };

  systemd.network.networks."10-wan" = {
    matchConfig.Name = "enp1s0";
    networkConfig.DHCP = "ipv4";
  };
}
