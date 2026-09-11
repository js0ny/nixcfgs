{
  pkgs,
  config,
  secrets,
  ...
}:
{
  js0ny = {
    apps = {
      terminal = {
        package = pkgs.kitty;
        exe = "kitty";
        desktop = "kitty.app";
        bundleIdentifier = "net.kovidgoyal.kitty";
      };
      interactiveShell = {
        package = pkgs.fish;
        exe = "fish";
        desktop = "";
      };
      browser = {
        package = pkgs.firefox;
        exe = "firefox";
        desktop = "Firefox.app";
        bundleIdentifier = "org.mozilla.firefox";
      };
      fileManager = {
        tui = {
          package = pkgs.yazi;
          exe = "yazi";
          desktop = "yazi.desktop";
        };
      };
      editor = {
        tui = {
          package = pkgs.neovim;
          exe = "nvim";
        };
        gui = {
          package = pkgs.neovide;
          exe = "neovide";
          desktop = "Neovide.app";
          bundleIdentifier = "com.neovide.neovide";
        };
      };
    };
    hardware = {
      type = "bare-metal";
    };
    desktop.enable = true;
    homebrew.enable = true;
    host = {
      hostName = "zen";
      timezones = [
        "Europe/London"
        "Etc/UTC"
        "Asia/Shanghai"
      ];
      flakeDir = "${config.js0ny.user.home}/Atelier/dot/nixcfgs";
    };
  };
  nixdots = {
    services = {
      tailscale = {
        enable = true;
        ip = "100.68.20.54";
        ipv6 = "fd7a:115c:a1e0::df37:1436";
        magicDNS = "${config.js0ny.host.hostName}.tailee8d62.ts.net";
      };
    };
    style = {
      enable = true;
      stylix.enable = true;
    };
    programs = {
      thunderbird.enable = true;
    };
    sops = {
      enable = true;
      yamlFile = secrets + "/hosts/zen.yaml";
      keyFile = "${config.js0ny.user.home}/.config/sops/age/keys.txt";
    };
  };
}
