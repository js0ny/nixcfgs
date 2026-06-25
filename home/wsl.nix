{ pkgs, ... }:
{
  imports = [
    ./linux-base.nix
    ./programs/shell/zsh.nix
    ./programs/editors/nvim
  ];

  dconf.enable = false;
}
