{ pkgs, ... }:
{
  imports = [
    ./linux-base.nix
    ./programs/shell/zsh.nix
    ./programs/editors/nvim
    ./programs/opencode
  ];

  dconf.enable = false;
}

