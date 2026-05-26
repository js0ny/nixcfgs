{ config, ... }:
{
  time.timeZone = builtins.head config.nixdots.core.timezones;
  programs.ssh.knownHosts = config.nixdefs.misc.ssh.knownHosts;
  system.primaryUser = config.nixdots.user.name;
  networking.computerName = config.nixdots.core.hostname;
  programs.zsh.enable = true;
}
