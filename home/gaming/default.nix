{ pkgs, ... }:
{
  home.packages = with pkgs; [
    scanmem
    localPkgs.noname

    localPkgs.wine.clrmamepro
  ];
}
