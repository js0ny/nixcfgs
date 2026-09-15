{
  pkgs,
  config,
  inputs,
  secrets,
  ...
}:
let
  avatar = inputs.bindeps + "/avatar/git.jpg";
  hosts = import ../../definitions/hosts.nix;
in
{
  js0ny = {
    geo = {
      longitude = -3.2;
      latitude = 55.95;
      city = "Guangzhou";
    };
    flatpak.enable = true;
    user.avatar = avatar;
    persist.enable = true;
    host = {
      hostName = "crystal";
      timezones = [
        "Asia/Shanghai"
        "Etc/UTC"
        "Europe/London"
      ];
      locales = {
        guiLocale = "zh-CN";
      };
      flakeDir = "${config.js0ny.user.home}/Atelier/dot/nixcfgs";
    };
    desktop = {
      enable = true;
      display = "wayland";
      displayManager = "regreet";
      session = [
        "hyprland"
        "niri"
        "kde"
      ];
    };
    hardware = {
      localInterfaces = [ "wlp3s0" ];
      cpu.nproc = 16;
      type = "bare-metal";
      gpu = {
        driver = "none";
        busIds = {
          nvidia = "PCI:1:0:0";
          amdgpu = "PCI:101:0:0";
        };
      };
      laptop = {
        enable = true;
        vendor = "asus";
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
          screen = if config.js0ny.hardware.gpu.driver == "none" then "amdgpu_bl1" else "amdgpu_bl2";
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
    tailscale = hosts.nixos.crystal.tailscale // {
      enable = true;
      authKeyFile = config.sops.secrets.tskey.path;
    };
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
  };
  sops = {
    defaultSopsFile = secrets + "/hosts/crystal.yaml";
    age = {
      keyFile = "${config.js0ny.user.home}/.config/sops/age/keys.txt";
      generateKey = false;
    };
    secrets.tskey = { };
  };
}
