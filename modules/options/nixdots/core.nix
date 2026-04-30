{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.nixdots = {
    user = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "pangu";
        description = "Primary user account name.";
      };
      home = lib.mkOption {
        type = lib.types.str;
        default =
          if pkgs.stdenv.isDarwin then
            "/Users/${config.nixdots.user.name}"
          else
            "/home/${config.nixdots.user.name}";
        description = "Primary user home directory.";
      };
      shell = lib.mkOption {
        type = lib.types.package;
        default = pkgs.bash;
        description = "Default / Login Shell for user.";
      };
      email = lib.mkOption {
        type = lib.types.str;
        default = "me@example.com";
      };
      avatar = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
    };

    core = {
      dots = lib.mkOption {
        type = lib.types.str;
        default = "${config.nixdots.user.home}/.dotfiles";
        description = "Path for dotfiles.";
      };
      flakeDir = lib.mkOption {
        type = lib.types.str;
        default = config.nixdots.core.dots;
        description = "Path for flake directory.";
      };
      hostname = lib.mkOption {
        type = lib.types.str;
        default = "nixos";
        description = "Hostname for the machine.";
      };
      timezones = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        example = [ "Etc/UTC" ];
        description = "Timezones for the system, the first item will be set as timezone.";
      };
      locales = {
        langcode = lib.mkOption {
          type = lib.types.str;
          default = "en_GB";
        };
        charset = lib.mkOption {
          type = lib.types.str;
          default = "UTF-8";
        };
        default = lib.mkOption {
          type = lib.types.str;
          default =
            let
              l = config.nixdots.core.locales;
            in
            "${l.langcode}.${l.charset}";
        };
        ietf = lib.mkOption {
          type = lib.types.str;
          readOnly = true;
          default = builtins.replaceStrings [ "_" "-" ] config.nixdots.core.locales.langcode;
        };
        guiLocale = lib.mkOption {
          type = lib.types.str;
          default = config.nixdots.core.locales.ietf;
        };
        settings = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = {
            LC_ALL = config.nixdots.core.locales.default;
          };
        };
      };
    };
    geo = {
      longitude = lib.mkOption {
        type = lib.types.nullOr lib.types.number;
      };
      latitude = lib.mkOption {
        type = lib.types.nullOr lib.types.number;
      };
      city = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
      };
    };
    services = {
      tailscale = {
        enable = lib.mkEnableOption "Enable Tailscale VPN client and service daemon.";
        ip = lib.mkOption {
          type = lib.types.str;
          default = "";
          example = "100.x.y.z";
          description = "The assigned Tailscale IPv4 address for this specific node.";
        };
        ipv6 = lib.mkOption {
          type = lib.types.str;
          default = "";
          example = "fd7a:115c:a1e0:ab12:4843:cd96:6253:abcd";
          description = "The assigned Tailscale IPv6 address for this specific node.";
        };
        magicDNS = lib.mkOption {
          type = lib.types.str;
          default = "";
          example = "host.tailexample.ts.net";
          description = "The MagicDNS hostname for this specific node.";
        };
        openFirewall = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Open UDP 41641 for Tailscale peer-to-peer connections.";
        };

        trustInterface = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Trust the Tailscale interface, allowing all incoming traffic from the Tailnet.";
        };

        authKeyFile = lib.mkOption {
          type = lib.types.str;
          default = null;
        };
      };
      syncthing = {
        enable = lib.mkEnableOption "Enable Syncthing file synchronization service.";
      };
      sshd = lib.mkOption {
        type = lib.types.bool;
        default = config.nixdots.server.enable;
        description = "Whether to enable the SSH daemon for remote access. This is typically enabled for headless or server machines.";
      };
      ollama = {
        enable = lib.mkEnableOption "Whether to enable ollama server for local large language models.";
        models = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [ "bge-m3" ];
          description = ''
            Download these models using ollama pull as soon as ollama.service has started.
          '';
        };
      };
    };
    pam = {
      howdy = {
        enable = lib.mkEnableOption "Enable Howdy facial recognition for PAM authentication.";
        setup = lib.mkEnableOption "This module requires human intervention to configure, please make sure you have done most of the steps.";
      };
    };
    networking = {
      nftables = {
        enable = lib.mkEnableOption "Enable nftables firewall backend.";
      };
    };
  };
}
