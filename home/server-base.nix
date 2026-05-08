{ pkgs, ... }:
{
  imports = [
    ./linux-base.nix
    ./programs/shell/zsh.nix
  ];

  dconf.enable = false;

  home.packages = with pkgs; [
    # keep-sorted start
    ghostty.terminfo
    kitty.kitten
    kitty.terminfo
    # keep-sorted end
  ];
}
