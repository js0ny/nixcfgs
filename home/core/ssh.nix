{
  config,
  lib,
  pkgs,
  ...
}:
let
  root = "root";
  port = config.nixdefs.endpoints.ssh.port;
in
{
  nixdots.persist.home = {
    directories = [ ".ssh" ];
  };
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = lib.mkForce {
      "git.js0ny.net" = {
        Port = port;
        IdentityFile = [ "~/.ssh/id_ed25519" ];
      };
      "polder" = {
        HostName = "100.92.207.11";
        User = "js0ny";
        Port = port;
        ForwardAgent = true;
        IdentityFile = [ "~/.ssh/id_ed25519" ];
      };
      "gl-mt3000" = {
        HostName = "192.168.8.1";
        User = root;
        Port = 22;
        IdentityFile = [ "~/.ssh/id_ed25519" ];
      };
      "zwinger" = {
        HostName = "100.97.155.65";
        User = "js0ny";
        Port = port;
        ForwardAgent = true;
        IdentityFile = [ "~/.ssh/id_ed25519" ];
      };
      "bauhaus" = {
        HostName = "100.65.81.67";
        User = "js0ny";
        Port = port;
        ForwardAgent = true;
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
      // lib.optionalAttrs pkgs.stdenv.isDarwin {
        UseKeychain = "yes";
      };
    };
  };
}
