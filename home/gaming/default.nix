{ pkgs, ... }:
{
  home.packages = with pkgs; [
    scanmem
    localPkgs.noname
    ludusavi
    lutris
    protontricks
    protonplus

    localPkgs.wine.clrmamepro
  ];
}
