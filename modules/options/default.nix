{...}: {
  imports = [
    ./core.nix
    ./style.nix
    ./laptop.nix
    ./programs.nix
    ./sops.nix
    ./desktop.nix
    ./machine.nix
    ./virtualisation.nix
    ./impermanence.nix
    ./server.nix
  ];
}
