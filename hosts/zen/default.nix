{ inputs, ... }:
{
  imports = [
    ../../definitions
    inputs.self.darwinModules.core
    inputs.self.darwinModules.determinate
    ./packages.nix
    ./dock.nix
    ./system.nix
    ./vars.nix
  ];

  home-manager.users."js0ny" = import ./home.nix;

  system.stateVersion = 6;

}
