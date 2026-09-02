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
  js0ny = {
    flatpak.enable = true;
    user.avatar = avatar;
    desktop = {
      enable = true;
      session = [
        "hyprland"
        "niri"
        "kde"
      ];
    };
    hardware = {
      cpu.nproc = 16;
      type = "bare-metal";
    };
    apps = {
      terminal = {
        package = pkgs.ghostty;
        exe = "ghostty";
        desktop = "com.mitchellh.ghostty.desktop";
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
  };
  nixdots = {
    persist = {
      enable = true;
      path = "/persist";
      nosnap.path = "/nosnap";
    };
    core = {
      hostname = "crystal";
      dots = "${config.js0ny.user.home}/Atelier/dot/nixcfgs";
      flakeDir = "${config.js0ny.user.home}/Atelier/dot/nixcfgs";
      timezones = [
        "Asia/Shanghai"
        "Etc/UTC"
        "Europe/London"
      ];
      locales = {
        guiLocale = "zh-CN";
      };
    };
    services = {
      tailscale = {
        enable = true;
        ip = "100.105.9.50";
        ipv6 = "fd7a:115c:a1e0::e701:932";
        magicDNS = "${config.nixdots.core.hostname}.tailee8d62.ts.net";
        authKeyFile = config.sops.secrets.tskey.path;
      };
      syncthing.enable = false;
      sshd.enable = true;
      ollama = {
        enable = false;
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
      fonts.extraFonts = [
        {
          package = pkgs.corefonts;
          name = "Corefonts";
        }
      ];
    };
    laptop = {
      enable = true;
      asus.enable = true;
      display = {
        connector = "eDP-1";
        makeModel = "Samsung Display Corp. ATNA40CU05-0  Unknown";
        VRR = true;
      };
      keyboard = {
        devicePath = "/dev/input/by-path/pci-0000:65:00.3-usb-0:4:1.0-event-mouse";
        name = "Asus Keyboard";
        idVendor = "0b05";
        idProduct = "19b6";
      };
      backlight = {
        screen = if config.nixdots.linux.gpu == "none" then "amdgpu_bl1" else "amdgpu_bl2";
        keyboard = "asus::kbd_backlight";
      };
      microphone = {
        name = "alsa_input.pci-0000_65_00.6.analog-stereo";
        description = "内置麦克风";
      };
      cameraIR = {
        devicePath = "/dev/video2";
      };
      touchpad = {
        devicePath = "/dev/input/by-path/platform-AMDI0010:00-event-mouse";
        name = "ASUP1208:00 093A:3011 Touchpad";
        vendorId = "093A";
        productId = "3011";
      };
    };
    programs = {
      steam.enable = true;
      obs-studio.enable = true;
      chromium.enable = true;
      firefox.enable = true;
      dolphin.enable = true;
      thunderbird.enable = true;
    };
    linux = {
      enable = true;
      lanzaboote = true;
      display = "wayland";
      gpu = "none";
      gpuBusIds = {
        nvidia = "PCI:1:0:0";
        amdgpu = "PCI:101:0:0";
      };
    };
    sops = {
      enable = true;
      yamlFile = secrets + "/hosts/crystal.yaml";
      keyFile = "${config.js0ny.user.home}/.config/sops/age/keys.txt";
    };
    geo = {
      longitude = -3.2;
      latitude = 55.95;
      city = "Guangzhou";
    };
  };
  sops.secrets.tskey = { };
}
