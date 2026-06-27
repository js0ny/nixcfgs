{
  flake.nixosModules.core =
    { config, ... }:
    {
      programs.ssh.knownHosts = config.nixdefs.misc.ssh.knownHosts;
      nixdots.persist.system = {
        files = [
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_ed25519_key.pub"
          "/etc/ssh/ssh_host_rsa_key"
          "/etc/ssh/ssh_host_rsa_key.pub"
        ];
      };
    };
  flake.darwinModules.core =
    { config, ... }:
    {
      programs.ssh.knownHosts = config.nixdefs.misc.ssh.knownHosts;
    };
  flake.homeModules.core =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
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
            User = "root";
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
    };
}
