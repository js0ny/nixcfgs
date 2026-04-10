{ pkgs, ... }:
{
  home.packages = with pkgs; [
    corefonts
  ];
}
