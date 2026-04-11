{ ... }:
{
  imports = [
    ../default.nix
    ./core.nix
    ./networking.nix
    ./nginx.nix
  ];
}
