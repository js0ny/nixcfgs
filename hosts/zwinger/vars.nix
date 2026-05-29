{
  pkgs,
  config,
  secrets,
  ...
}:
{
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
        authKeyFile = config.sops.secrets.tskey_zwinger.path;
      };
      # syncthing.enable = true;
      sshd = true;
    };
    networking.nftables.enable = true;
    style = {
      enable = false;
      stylix.enable = false;
    };
    # apps = {
    #   terminal = {
    #     package = pkgs.kitty;
    #     exe = "kitty";
    #     desktop = "kitty.desktop";
    #   };
    #   interactiveShell = {
    #     package = pkgs.fish;
    #     exe = "fish";
    #     desktop = "";
    #   };
    #   fileManager = {
    #     tui = {
    #       package = pkgs.yazi;
    #       exe = "yazi";
    #       desktop = "yazi.desktop";
    #     };
    #   };
    #   editor = {
    #     tui = {
    #       package = pkgs.neovim;
    #       exe = "nvim";
    #       desktop = "nvim.desktop";
    #     };
    #   };
    # };
    # pam.howdy.enable = false;
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
    };
    sops = {
      enable = true;
      yamlFile = secrets + /secrets.yaml;
      keyFile = "${config.nixdots.user.home}/.config/sops/age/keys.txt";
      secrets = {
        tskey_zwinger = { };
      };
    };
    geo = {
      city = "Nuremberg";
    };
  };
}
