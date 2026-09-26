{
  pkgs,
  config,
  secrets,
  ...
}:
{
  js0ny = {
    geo = {
      city = "Strasbourg";
    };
    host = {
      hostName = "polder";
      timezones = [
        "Etc/UTC"
        "Europe/Berlin"
        "Europe/London"
        "Asia/Shanghai"
      ];
    };
    apps = {
      interactiveShell = {
        package = pkgs.fish;
        exe = "fish";
        desktop = "";
      };
      editor = {
        tui = {
          package = pkgs.neovim;
          exe = "nvim";
        };
      };
    };
    tailscale = {
      enable = true;
      ipv4 = "100.92.207.11";
      # ipv6 = "fd7a:115c:a1e0::e701:932";
      magicDNS = "${config.js0ny.host.hostName}.tailee8d62.ts.net";
      authKeyFile = config.sops.secrets.tskey.path;
    };
    desktop.display = "none";
    hardware.gpu.driver = "none";
    style = {
      enable = false;
      stylix.enable = false;
    };
  };
  sops = {
    defaultSopsFile = secrets + "/hosts/polder.yaml";
    age = {
      keyFile = "${config.js0ny.user.home}/.config/sops/age/keys.txt";
      generateKey = false;
    };
    secrets.tskey.sopsFile = secrets + "/hosts/polder.yaml";
  };
}
