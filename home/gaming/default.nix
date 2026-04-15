{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lutris
    scanmem
    localPkgs.noname

    localPkgs.wine.clrmamepro
  ];
}
