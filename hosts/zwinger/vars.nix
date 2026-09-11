{
  config,
  secrets,
  ...
}:
let
  hosts = import ../../definitions/hosts.nix;
in
{
  sops.secrets.tskey = {
    sopsFile = secrets + "/hosts/zwinger.yaml";
  };
  js0ny = {
    geo = {
      city = "Nuremberg";
    };
    host = {
      hostName = "zwinger";
      timezones = [
        "Etc/UTC"
        "Europe/Berlin"
        "Europe/London"
        "Asia/Shanghai"
      ];
    };
    persist.enable = true;
    tailscale = hosts.nixos.zwinger.tailscale // {
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
      ip = "178.104.159.210";
      openHttp = true;
    };
    sops = {
      enable = true;
      keyFile = "/etc/ssh/agekey.txt";
    };
  };
}
