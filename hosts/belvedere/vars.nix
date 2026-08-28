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
    persist = {
      enable = true;
      path = "/persist";
      nosnap.path = "/nosnap";
    };
    core = {
      hostname = "belvedere";
      timezones = [
        "Etc/UTC"
        "Europe/Vienna"
        "Europe/London"
        "Asia/Shanghai"
      ];
    };
    services = {
      tailscale = {
        enable = true;
        ip = "100.92.207.11";
        # ipv6 = "fd7a:115c:a1e0::e701:932";
        magicDNS = "${config.nixdots.core.hostname}.tailee8d62.ts.net";
        authKeyFile = config.sops.secrets.tskey.path;
        exitNode = true;
      };
      sshd.enable = true;
      ollama = {
        enable = false;
      };
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
      ip = config.secrets.plain.belvedere.ipv4;
      openHttp = true;
      openQuic = true;
    };
    sops = {
      enable = true;
      yamlFile = secrets + "/hosts/belvedere.yaml";
      keyFile = "/persist/etc/ssh/agekey.txt";
    };
    geo = {
      city = "Vienna";
    };
  };
}
