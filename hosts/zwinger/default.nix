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

  nixpkgs.config.allowUnfree = true;

  imports = [
    ./disko.nix
    ./vars.nix

    nixcfgs.nixosModules.server
    inputs.srvos.nixosModules.hardware-hetzner-cloud
    ../../nixos/services/cloudflare.nix
    ../../nixos/services/matrix
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

  networking = {
    firewall = {
      enable = true;
    };
  };

  systemd.tmpfiles.rules = [
    "z /var/lib/private 0700 root root -"
  ];
  systemd.network.networks."10-wan" = {
    matchConfig.Name = "enp1s0"; # 对应你 networkctl list 里的名称
    networkConfig.DHCP = "ipv4";
  };
}
