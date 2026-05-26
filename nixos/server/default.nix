{ ... }:
{
  imports = [
    ../.
    ./core.nix
    ./networking.nix
    ./nginx.nix
  ];
}
