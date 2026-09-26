{ config, ... }:
{
  programs.ssh.knownHosts = config.nixdefs.misc.ssh.knownHosts;
}
