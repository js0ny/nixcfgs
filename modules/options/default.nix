{ myLib, ... }:
{
  imports = [
    ./nixdefs
    ./nixdots
    ./hardware.nix
    ./apps.nix
    ./packaging.nix
    ./desktop.nix
    ./primaryUser.nix
  ];
}
