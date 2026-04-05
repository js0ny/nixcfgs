{...}: {
  imports = [
    ./configuration.nix
    ./do-not-track.nix
    ./networkmanager.nix
    ./nftables.nix
    ./packages.nix
    ./sshd.nix
  ];
}
