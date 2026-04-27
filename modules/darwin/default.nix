{ config, ... }:
{
  imports = [
    ./brew.nix
    ./core.nix
    ./determinate.nix
    ./tailscale.nix
    ./pam.nix
    ./finder.nix
    ../options
    ../common/system.nix
  ];
}
