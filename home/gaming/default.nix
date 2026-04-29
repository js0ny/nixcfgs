{ pkgs, ... }:
{
  home.packages = with pkgs; [
    scanmem
    localPkgs.noname
    ludusavi

    localPkgs.wine.clrmamepro
  ];
}
