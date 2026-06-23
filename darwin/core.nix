{ pkgs, config, ... }:
{
  time.timeZone = builtins.head config.nixdots.core.timezones;
  programs.ssh.knownHosts = config.nixdefs.misc.ssh.knownHosts;
  system.primaryUser = config.nixdots.user.name;
  networking.computerName = config.nixdots.core.hostname;
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    iproute2mac
    # use gnu-compatible coreutils
    uutils-coreutils-noprefix
    uutils-findutils
    gnused
    gawk
    gnutar
    gzip
    getopt
  ];
  environment.variables = import ../common/do-not-track-vars.nix;
}
