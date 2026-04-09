{...}: {
  imports = [
    ./configuration.nix
    ./networkmanager.nix
    ./nftables.nix
    ./packages.nix
    ./sshd.nix
  ];
}
