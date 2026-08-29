{
  pkgs,
  secrets,
  ...
}:
{
  imports = [
    "${secrets}/nixos/nm.nix"
    "${secrets}/nixos/wireguard.nix"
  ];
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-openvpn
      networkmanager-fortisslvpn
    ];
  };
  nixdots.persist.system.directories = [ "/etc/NetworkManager/system-connections" ];

  js0ny.user.groups = [ "networkmanager" ];
}
