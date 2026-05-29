{ ... }:
{
  imports = [
    # keep-sorted start
    ./configuration.nix
    ./impermanence.nix
    ./nftables.nix
    ./packages.nix
    ./sops.nix
    ./ssh.nix
    ./sshd.nix
    ./tailscale.nix
    ./tuned.nix
    ./wsl.nix
    # keep-sorted end
  ];
}
