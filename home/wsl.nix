{ pkgs, ... }:
{
  imports = [
    ./linux-base.nix
    ./programs/editors/nvim
  ];

  dconf.enable = false;
}
