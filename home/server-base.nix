{ pkgs, ... }:
{
  imports = [
    ./linux-base.nix
    ./programs/shell/zsh.nix
  ];
  home.packages = with pkgs; [
    kitty.terminfo
    kitty.kitten
    ghostty.terminfo
  ];
}
