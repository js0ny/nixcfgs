{
  config,
  lib,
  pkgs,
  ...
}:
let
  port = config.nixdefs.endpoints.ssh.port;
  hosts = (import ../../../definitions/hosts.nix).nixos;
  mkTailscaleHost = _: host: {
    HostName = host.tailscaleIp;
    User = "js0ny";
    Port = port;
    ForwardAgent = true;
    IdentityFile = [ "~/.ssh/id_ed25519" ];
  };
in
{
  nixdots.persist.home = {
    directories = [ ".ssh" ];
  };
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = lib.mkForce (
      {
        "github.com" = {
          HostName = "ssh.github.com";
          Port = 443;
          User = "git";
        };
        "git.js0ny.net" = {
          Port = 2220; # see forgejo/default.nix
          IdentityFile = [ "~/.ssh/id_ed25519" ];
        };
        "gl-mt3000" = {
          HostName = "192.168.8.1";
          User = "root";
          Port = 22;
          IdentityFile = [ "~/.ssh/id_ed25519" ];
        };
        "*" = {
          ForwardAgent = false;
          AddKeysToAgent = "yes";
          Compression = false;
          ServerAliveInterval = 60;
          ServerAliveCountMax = 3;
          HashKnownHosts = false;
          UserKnownHostsFile = "~/.ssh/known_hosts";
          ControlMaster = "auto";
          ControlPath = "~/.ssh/master-%r@%n:%p";
          ControlPersist = "10m";
        }
        // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
          UseKeychain = "yes";
        };
      }
      // lib.mapAttrs mkTailscaleHost hosts
    );
  };
}
