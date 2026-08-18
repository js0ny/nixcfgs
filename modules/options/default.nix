{ myLib, ... }:
{
  imports = [
    ./nixdefs
    ./nixdots
    ./hardware.nix
    ./apps.nix
  ];
}
