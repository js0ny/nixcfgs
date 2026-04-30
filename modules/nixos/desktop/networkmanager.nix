{ pkgs, config, ... }:
let
  username = config.nixdots.user.name;
in
{
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
