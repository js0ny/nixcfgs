{
  pkgs,
  config,
  secrets,
  ...
}:
{
  sops.secrets.tskey = {
    sopsFile = secrets + "/hosts/revival.yaml";
  };
  nixdots = {
    persist.enable = true;
    core = {
      hostname = "revival";
      timezones = [
        "Etc/UTC"
        "Asia/Shanghai"
      ];
    };
    services = {
      tailscale = {
        enable = true;
        ip = "100.71.26.71";
        # ipv6 = "fd7a:115c:a1e0::e701:932";
        magicDNS = "${config.nixdots.core.hostname}.tailee8d62.ts.net";
        authKeyFile = config.sops.secrets.tskey.path;
      };
      # syncthing.enable = true;
      sshd.enable = true;
    };
    networking.nftables.enable = true;
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
      keyFile = "/persist/etc/ssh/agekey.txt";
    };
    geo = {
      city = "Guangzhou";
    };
  };
}
