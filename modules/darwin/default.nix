{ config, ... }:
{
  imports = [
    ./brew.nix
    ./core.nix
    ./determinate.nix
    ./tailscale.nix
    ./pam.nix
    ../options
    ../common/system.nix
  ];
}
