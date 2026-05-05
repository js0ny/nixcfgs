{ pkgs, ... }:
{
  imports = [
    ./linux-base.nix
    ./programs/shell/zsh.nix
  ];

  dconf.enable = false;

  home.packages = with pkgs; [
    kitty.terminfo
    kitty.kitten
    ghostty.terminfo
  ];
}
