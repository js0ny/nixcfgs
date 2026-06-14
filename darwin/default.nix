{ config, ... }:
{
  imports = [
    # keep-sorted start
    ../common/hm.nix
    ../common/system.nix
    ../definitions
    ../options
    ./brew.nix
    ./core.nix
    ./determinate.nix
    ./finder.nix
    ./pam.nix
    ./stylix.nix
    ./tailscale.nix
    # keep-sorted end
  ];
}
