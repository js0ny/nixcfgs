{ ... }:
{
  imports = [
    ../../darwin

    ./packages.nix
    ./dock.nix
    ./system.nix
    ./vars.nix

  ];

  home-manager.users."js0ny" = import ./home.nix;

  system.stateVersion = 6;
}
