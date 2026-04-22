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
}
