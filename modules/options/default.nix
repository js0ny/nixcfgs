{ myLib, ... }:
{
  imports = [
    ./nixdefs
    ./hardware.nix
    ./apps.nix
    ./style.nix
    ./packaging.nix
    ./desktop.nix
    ./persist.nix
    ./primaryUser.nix
    ./host.nix
    ./geo.nix
    ./tailscale.nix
  ];
}
