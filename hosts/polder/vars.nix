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
  };
  sops.secrets.tskey = {
    sopsFile = secrets + "/hosts/polder.yaml";
  };
  nixdots = {
    services = {
      ollama = {
        enable = true;
        models = [ "bge-m3" ];
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
      ip = config.secrets.plain.polder.ipv4;
      openHttp = true;
      openQuic = true;
    };
    sops = {
      enable = true;
      yamlFile = secrets + "/hosts/polder.yaml";
      keyFile = "${config.js0ny.user.home}/.config/sops/age/keys.txt";
    };
  };
}
