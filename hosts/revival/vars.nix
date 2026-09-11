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
  sops.secrets.tskey = {
    sopsFile = secrets + "/hosts/revival.yaml";
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
    tailscale = hosts.nixos.revival.tailscale // {
      enable = true;
      authKeyFile = config.sops.secrets.tskey.path;
    };
  };
  nixdots = {
    style = {
      enable = false;
      stylix.enable = false;
    };
    linux = {
      enable = true;
      display = "none";
      gpu = "none";
    };
    server = {
      enable = true;
    };
    sops = {
      enable = true;
      keyFile = "/etc/ssh/agekey.txt";
    };
  };
}
