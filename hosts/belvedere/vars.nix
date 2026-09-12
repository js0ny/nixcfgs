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
  sops = {
    defaultSopsFile = secrets + "/hosts/belvedere.yaml";
    age = {
      keyFile = "/etc/ssh/agekey.txt";
      generateKey = false;
    };
    secrets.tskey.sopsFile = secrets + "/hosts/belvedere.yaml";
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
    desktop.display = "none";
    hardware.gpu.driver = "none";
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
}
