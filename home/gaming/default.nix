{ pkgs, ... }:
{
  home.packages = with pkgs; [
    scanmem
    localPkgs.noname
    ludusavi
    lutris
    protontricks
    protonplus

    (localPkgs.wine.clrmamepro.override {
      winepkg = pkgs.wineWow64Packages.waylandFull;
    })
  ];
}
