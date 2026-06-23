{ pkgs, ... }:
{
  imports = [
    # keep-sorted start
    ../common/hm.nix
    ../definitions
    ../options
    ./brew.nix
    ./core.nix
    ./determinate.nix
    ./finder.nix
    ./pam.nix
    ./sshd.nix
    ./stylix.nix
    ./tailscale.nix
    # keep-sorted end
  ];
}
