{ inputs, ... }:
{
  imports = [
    ../../common/hm.nix
    ../../definitions
    ../../options
    inputs.self.darwinModules.darwin

    ./packages.nix
    ./dock.nix
    ./system.nix
    ./vars.nix

  ];

  home-manager.users."js0ny" = import ./home.nix;

  system.stateVersion = 6;

  programs.fish.enable = true;
}
