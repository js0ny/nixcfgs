{ pkgs, ... }:
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
}
