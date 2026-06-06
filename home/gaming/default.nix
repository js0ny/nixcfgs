{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    scanmem
    localPkgs.noname
    ludusavi
    protontricks
    protonplus

    (localPkgs.wine.clrmamepro.override {
      winepkg = pkgs.wineWow64Packages.waylandFull;
    })
  ];
}
