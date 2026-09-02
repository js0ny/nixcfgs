{
  inputs,
  secrets,
  ...
}:
let
  mod = inputs.self.nixosModules;
in
{
  system.stateVersion = "26.11";

  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./vars.nix

    mod.server

    mod.fail2ban
    mod.prometheus-node
    mod.rclone

    (secrets + "/nixos/iw-home.nix")

  ];

  home-manager.users."js0ny" = import ./home.nix;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "console=ttyS0,115200n8"
    "console=tty0"
  ];

  systemd.network.networks."10-wan" = {
    matchConfig.Name = "wlp4s0";
    networkConfig.DHCP = "ipv4";
  };
  networking = {
    firewall.enable = true;

    wireless.iwd.enable = true;
    useNetworkd = true;
    firewall.trustedInterfaces = [ "wlan0" ];
  };

  services.sing-box.enable = true;

}
