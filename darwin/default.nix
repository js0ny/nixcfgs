{ config, ... }:
{
  imports = [
    # keep-sorted start
    ../common/system.nix
    ../options
    ./brew.nix
    ./core.nix
    ./determinate.nix
    ./finder.nix
    ./pam.nix
    ./tailscale.nix
    # keep-sorted end
  ];
}
