{
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
    secrets.tskey.sopsFile = secrets + "/hosts/zwinger.yaml";
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
    desktop.display = "none";
    hardware.gpu.driver = "none";
    style = {
      enable = false;
      stylix.enable = false;
    };
    tailscale = hosts.nixos.zwinger.tailscale // {
      enable = true;
      authKeyFile = config.sops.secrets.tskey.path;
    };
  };
}
