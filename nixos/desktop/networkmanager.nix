{
  pkgs,
  config,
  secrets,
  ...
}:
let
  username = config.nixdots.user.name;
in
{
  imports = [
    "${secrets}/nixos/nm.nix"
    "${secrets}/nixos/wireguard.nix"
  ];
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };
  nixdots.persist.system = {
    directories = [
      "/etc/NetworkManager/system-connections"
    ];
  };
  users.users."${username}".extraGroups = [ "networkmanager" ];
}
