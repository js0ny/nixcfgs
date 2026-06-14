{
  pkgs,
  config,
  secrets,
  ...
}:
{
  nixdots = {
    persist.enable = false;
    darwin.enable = true;
    user = {
      name = "js0ny";
      home = "/Users/js0ny";
      shell = pkgs.zsh;
    };
    core = {
      dots = "${config.nixdots.user.home}/Atelier/dot/nixcfgs";
      flakeDir = "${config.nixdots.user.home}/Atelier/dot/nixcfgs";
      hostname = "zen";
      timezones = [
        "Europe/London"
        "Etc/UTC"
        "Asia/Shanghai"
      ];
    };
    services = {
      tailscale = {
        enable = true;
        ip = "100.68.20.54";
        ipv6 = "fd7a:115c:a1e0::df37:1436";
        magicDNS = "${config.nixdots.core.hostname}.tailee8d62.ts.net";
      };
      syncthing.enable = true;
      sshd = false;
    };
    style = {
      enable = true;
      stylix.enable = true;
    };
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
    programs = {
      obs-studio = {
        enable = false;
      };
      chromium.enable = true;
      firefox.enable = true;
      dolphin.enable = true;
      thunderbird.enable = true;
    };
    features = {
      enable = true;
      media.mpv = {
        enable = true;
        enableNativeFrontend = true;
      };
    };
    machine = {
      role = "host";
    };
    desktop = {
      enable = true;
    };
    sops = {
      enable = true;
      yamlFile = secrets + /hosts/zen.yaml;
      keyFile = "${config.nixdots.user.home}/.config/sops/age/keys.txt";
    };
  };
}
