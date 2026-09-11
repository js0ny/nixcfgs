{
  pkgs,
  config,
  secrets,
  ...
}:
let
  hosts = import ../../definitions/hosts.nix;
in
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
    tailscale = hosts.nixos.belvedere.tailscale // {
      enable = true;
      authKeyFile = config.sops.secrets.tskey.path;
    };
  };
  nixdots = {
    services = {
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
