{
  pkgs,
  config,
  secrets,
  ...
}:
{
  sops.secrets.tskey = {
    sopsFile = secrets + /hosts/zwinger.yaml;
  };
  nixdots = {
    persist.enable = true;
    user = {
      name = "js0ny";
      shell = pkgs.zsh;
    };
    core = {
      hostname = "zwinger";
      timezones = [
        "Etc/UTC"
        "Europe/Berlin"
        "Europe/London"
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
      sshd = true;
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
    machine = {
      role = "guest";
      compat = false;
      virtualisation = {
        oci-container.podman = true;
      };
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
    geo = {
      city = "Nuremberg";
    };
  };
}
