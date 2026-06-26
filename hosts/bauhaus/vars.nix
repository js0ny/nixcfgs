{
  pkgs,
  config,
  inputs,
  secrets,
  ...
}:
let
  avatar = inputs.bindeps + "/avatar/git.jpg";
in
{
  imports = [ ../../common/extra-fonts.nix ];
  nixdots = {
    persist = {
      enable = true;
      path = "/persist";
      nosnap.path = "/nosnap";
    };
    user = {
      name = "js0ny";
      shell = pkgs.zsh;
      avatar = avatar;
    };
    core = {
      hostname = "bauhaus";
      dots = "${config.nixdots.user.home}/Atelier/dot/nixcfgs";
      flakeDir = "${config.nixdots.user.home}/Atelier/dot/nixcfgs";
      timezones = [
        "Europe/London"
        "Etc/UTC"
        "Asia/Shanghai"
      ];
      locales = {
        guiLocale = "zh-CN";
      };
    };
    services = {
      tailscale = {
        enable = true;
        ip = "100.65.81.67";
        ipv6 = "fd7a:115c:a1e0::f735:5144";
        magicDNS = "${config.nixdots.core.hostname}.tailee8d62.ts.net";
        authKeyFile = config.sops.secrets.tskey.path;
      };
      syncthing.enable = false;
      sshd.enable = true;
      ollama = {
        enable = true;
        models = [ "bge-m3" ];
      };
    };
    networking.nftables.enable = true;
    style = {
      enable = true;
      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";
      };
    };
    apps = {
      terminal = {
        package = pkgs.kitty;
        exe = "kitty";
        desktop = "kitty.desktop";
      };
      interactiveShell = {
        package = pkgs.fish;
        exe = "fish";
        desktop = "";
      };
      browser = {
        package = pkgs.firefox;
        exe = "firefox";
        desktop = "firefox.desktop";
      };
      fileManager = {
        gui = {
          package = pkgs.kdePackages.dolphin;
          exe = "dolphin";
          desktop = "org.kde.dolphin.desktop";
        };
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
          desktop = "nvim.desktop";
        };
        gui = {
          package = pkgs.neovim;
          exe = "nvim";
          desktop = "nvim.desktop";
        };
      };
    };
    pam.howdy.enable = false;
    programs = {
      steam.enable = true;
      zsh.enable = false;
      obs-studio.enable = true;
      chromium.enable = false;
      firefox.enable = true;
      dolphin.enable = true;
      thunderbird.enable = true;
    };
    features = {
      preferGtk = true;
      media = {
        obs-studio.enable = false;
        mpv = {
          enable = true;
          enableNativeFrontend = false;
        };
      };
      tools = {
        vicinae.enable = true;
      };
      flatpak.enable = true;
    };
    linux = {
      enable = true;
      lanzaboote = false;
      display = "wayland";
      gpu = "nvidia";
    };
    machine = {
      role = "host";
      compat = true;
      virtualisation = {
        waydroid = false;
        libvirt.enable = true;
        oci-container.podman = true;
      };
    };
    desktop = {
      enable = true;
      dm = "sddm";
      autoLogin = true;
      session = [
        "niri"
        "kde"
        "gnome"
        "mangowc"
        "hyprland"
        "sway"
      ];
      wm = {
        shell = "dank-material-shell";
        clipboard = "vicinae";
      };
    };
    sops = {
      enable = true;
      yamlFile = secrets + /hosts/bauhaus.yaml;
      keyFile = "/etc/ssh/agekey.txt";
    };
    geo = {
      longitude = -3.2;
      latitude = 55.95;
      city = "Edinburgh";
    };
    devenvs = {
      c = {
        enable = true;
        global = true;
      };
      nix = {
        enable = true;
        global = true;
      };
      lua = {
        enable = true;
        global = true;
      };
      typst = {
        enable = true;
        global = true;
      };
      configfiles = {
        enable = true;
        global = true;
      };
      webdev = {
        enable = true;
        global = true;
      };
      rust = {
        enable = true;
        global = true;
      };
      python = {
        enable = true;
        global = true;
      };
      dotnet = {
        enable = true;
        global = true;
      };
    };
  };
  sops.secrets.tskey = { };
}
