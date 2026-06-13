{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    scanmem
    misc.apps.noname
    ludusavi
    protontricks
    protonplus

    (misc.apps.wine.clrmamepro.override {
      winepkg = pkgs.wineWow64Packages.waylandFull;
    })
  ];
}
