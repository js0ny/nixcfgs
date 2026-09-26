{
  pkgs,
  config,
  secrets,
  ...
}:
let
  hosts = import ../../definitions/hosts.nix;
in
{
  sops = {
    age = {
      keyFile = "/etc/ssh/agekey.txt";
      generateKey = false;
    };
    secrets.tskey.sopsFile = secrets + "/hosts/revival.yaml";
  };
  js0ny = {
    geo = {
      city = "Guangzhou";
    };
    host = {
      hostName = "revival";
      timezones = [
        "Etc/UTC"
        "Asia/Shanghai"
      ];
    };
    persist.enable = true;
    desktop.display = "none";
    hardware.gpu.driver = "none";
    style = {
      enable = false;
      stylix.enable = false;
    };
    tailscale = hosts.nixos.revival.tailscale // {
      enable = true;
      authKeyFile = config.sops.secrets.tskey.path;
    };
  };
}
