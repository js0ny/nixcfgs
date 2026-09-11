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
      city = "Edinburgh";
    };
    flatpak.enable = true;
    user.avatar = avatar;
    persist.enable = true;
    desktop = {
      enable = true;
      autoLogin = true;
      session = [
        "hyprland"
        "niri"
        "kde"
        "gnome"
        "sway"
      ];
    };
    hardware = {
      cpu.nproc = 16;
      type = "bare-metal";
    };
    apps = {
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
          package = pkgs.nautilus;
          exe = "nautilus";
          desktop = "org.gnome.Nautilus.desktop";
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
    host = {
      hostName = "bauhaus";
      timezones = [
        "Europe/London"
        "Etc/UTC"
        "Asia/Shanghai"
      ];
      locales = {
        guiLocale = "zh-CN";
      };
      flakeDir = "${config.js0ny.user.home}/Atelier/dot/nixcfgs";
    };
    tailscale = hosts.nixos.bauhaus.tailscale // {
      enable = true;
      authKeyFile = config.sops.secrets.tskey.path;
    };
  };
  nixdots = {
    services = {
      ollama = {
        enable = true;
        models = [
          "bge-m3"
          "qwen3.6:27b"
        ];
      };
    };
    style = {
      enable = true;
      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";
      };
      fonts.extraFonts = [
        {
          package = pkgs.vollkorn;
          name = "Vollkorn";
        }
        {
          package = pkgs.font-awesome;
          name = "Font Awesome 6 Free";
        }
        {
          package = pkgs.ubuntu-sans;
          name = "Ubuntu Sans";
        }
        {
          package = pkgs.nerd-fonts.fira-code;
          name = "Fira Code Nerd Font";
        }
        {
          package = pkgs.cinzel;
          name = "Cinzel";
        }
        {
          package = pkgs.jigmo;
          name = "Jigmo";
        }
      ];
    };
    linux = {
      enable = true;
      lanzaboote = false;
      display = "wayland";
      gpu = "nvidia";
    };
    sops = {
      enable = true;
      yamlFile = secrets + "/hosts/bauhaus.yaml";
      keyFile = "/etc/ssh/agekey.txt";
    };
  };
  sops.secrets.tskey = { };
}
