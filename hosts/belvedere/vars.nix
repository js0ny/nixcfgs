{
  pkgs,
  config,
  secrets,
  ...
}:
{
  sops.secrets.tskey = {
    sopsFile = secrets + "/hosts/belvedere.yaml";
  };
  js0ny = {
    geo = {
      city = "Vienna";
    };
    host = {
      hostName = "belvedere";
      timezones = [
        "Etc/UTC"
        "Europe/Vienna"
        "Europe/London"
        "Asia/Shanghai"
      ];
    };
    persist.enable = true;
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
  };
  nixdots = {
    services = {
      tailscale = {
        enable = true;
        ip = "100.92.207.11";
        # ipv6 = "fd7a:115c:a1e0::e701:932";
        magicDNS = "${config.js0ny.host.hostName}.tailee8d62.ts.net";
        authKeyFile = config.sops.secrets.tskey.path;
        exitNode = true;
      };
      ollama = {
        enable = false;
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
      ip = config.secrets.plain.belvedere.ipv4;
      openHttp = true;
      openQuic = true;
    };
    sops = {
      enable = true;
      yamlFile = secrets + "/hosts/belvedere.yaml";
      keyFile = "/etc/ssh/agekey.txt";
    };
  };
}
