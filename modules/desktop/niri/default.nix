{
  flake.nixosModules.niri = import ./nixos.nix;
  flake.homeModules.niri = import ./module.nix;
}
