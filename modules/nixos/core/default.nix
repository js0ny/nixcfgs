{ ... }:
{
  imports = [
    ./configuration.nix
    ./nftables.nix
    ./packages.nix
    ./sshd.nix
    ./ssh.nix
  ];
}
