{ config, ... }:
{
  imports = [
    ./brew.nix
    ./determinate.nix
    ./tailscale.nix
    ./pam.nix
    ../options
    ../common/system.nix
  ];
  time.timeZone = builtins.head config.nixdots.core.timezones;
  programs.ssh.knownHosts = config.nixdefs.misc.ssh.knownHosts;
  system.primaryUser = config.nixdots.user.name;
  networking.computerName = config.nixdots.core.hostname;
}
