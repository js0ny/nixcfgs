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
}
