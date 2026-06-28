{ pkgs, ... }:
{
  imports = [
    ./linux-base.nix
    ../../modules/home/programs/editors/nvim/module.nix
  ];

  dconf.enable = false;
}
