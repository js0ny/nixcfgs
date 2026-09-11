{
  config,
  secrets,
  ...
}:
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
  };
  nixdots = {
    services = {
      tailscale = {
        enable = true;
        ip = "100.71.26.71";
        # ipv6 = "fd7a:115c:a1e0::e701:932";
        magicDNS = "${config.js0ny.host.hostName}.tailee8d62.ts.net";
        authKeyFile = config.sops.secrets.tskey.path;
      };
    };
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
