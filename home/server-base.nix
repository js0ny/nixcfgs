{ pkgs, ... }:
{
  imports = [
    ./linux-base.nix
    ./programs/shell/zsh.nix
  ];

  dconf.enable = false;
}
