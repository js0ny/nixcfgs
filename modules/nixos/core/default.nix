{ ... }:
{
  imports = [
    ./configuration.nix
    ./nftables.nix
    ./packages.nix
    ./sshd.nix
    ./ssh.nix
    ./impermanence.nix
    ./sops.nix
    ./tuned.nix
  ];
}
