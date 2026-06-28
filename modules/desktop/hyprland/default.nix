{
  flake.nixosModules.hyprland = import ./nixos.nix;
  flake.homeModules.hyprland = import ./module.nix;
}
