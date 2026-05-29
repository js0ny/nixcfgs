{
  pkgs,
  config,
  secrets,
  ...
}:
{
  sops.secrets.tskey = {
    sopsFile = secrets + /hosts/polder.yaml;
  };
  nixdots = {
    user = {
      name = "js0ny";
      shell = pkgs.zsh;
    };
    core = {
      hostname = "polder";
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
        ip = "100.92.207.11";
        # ipv6 = "fd7a:115c:a1e0::e701:932";
        magicDNS = "${config.nixdots.core.hostname}.tailee8d62.ts.net";
        authKeyFile = config.sops.secrets.tskey.path;
      };
      sshd = true;
      ollama = {
        enable = true;
        models = [ "bge-m3" ];
      };
    };
    networking.nftables.enable = true;
    style = {
      enable = false;
      stylix.enable = false;
    };
    apps = {
      interactiveShell = {
        package = pkgs.fish;
        exe = "fish";
        desktop = "";
      };
      fileManager = {
        tui = {
          package = pkgs.yazi;
          exe = "yazi";
        };
      };
      editor = {
        tui = {
          package = pkgs.neovim;
          exe = "nvim";
        };
      };
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
      ip = config.secrets.plain.polder.ipv4;
      openHttp = true;
      openQuic = true;
    };
    sops = {
      enable = true;
      yamlFile = secrets + /hosts/polder.yaml;
      keyFile = "${config.nixdots.user.home}/.config/sops/age/keys.txt";
    };
    geo = {
      city = "Frankfurt";
    };
  };
}
