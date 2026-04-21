{
  pkgs,
  lib,
  config,
  ...
}:
let
  types = import ./types.nix { inherit lib; };
  appType = types.appType;
in
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
      sshKeys = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "List of SSH public keys for the user.";
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
    };
    # This section is for home-manager and nix-darwin
    apps = {
      terminal = lib.mkOption {
        type = appType;
        default = {
          package = pkgs.kitty;
          exe = "kitty";
          desktop = "kitty.desktop";
          bundleIdentifier = "net.kovidgoyal.kitty";
        };
      };
      interactiveShell = lib.mkOption {
        type = appType;
        default = {
          package = config.nixdots.user.shell;
          exe = lib.getExe config.nixdots.user.shell;
          desktop = "";
          bundleIdentifier = "";
        };
      };
      browser = lib.mkOption {
        type = appType;
        default = {
          package = pkgs.firefox;
          exe = "firefox";
          desktop = "firefox.desktop";
          bundleIdentifier = "org.mozilla.firefox";
        };
      };
      fileManager = {
        gui = lib.mkOption {
          type = appType;
          default = {
            package = pkgs.thunar;
            exe = "thunar";
            desktop = "Thunar.desktop";
            bundleIdentifier = "";
          };
        };
        tui = lib.mkOption {
          type = appType;
          default = {
            package = pkgs.yazi;
            exe = "yazi";
            desktop = "yazi.desktop";
            bundleIdentifier = "";
          };
        };
      };
      editor = {
        tui = lib.mkOption {
          type = appType;
          default = {
            package = pkgs.vim;
            exe = "vim";
            desktop = "vim.desktop";
            bundleIdentifier = "";
          };
        };
        gui = lib.mkOption {
          type = appType;
          default = {
            package = pkgs.vim;
            exe = "vim";
            desktop = "vim.desktop";
            bundleIdentifier = "";
          };
        };
      };
    };
    pam = {
      howdy = {
        enable = lib.mkEnableOption "Enable Howdy facial recognition for PAM authentication.";
      };
    };
    networking = {
      nftables = {
        enable = lib.mkEnableOption "Enable nftables firewall backend.";
      };
    };
  };
}
