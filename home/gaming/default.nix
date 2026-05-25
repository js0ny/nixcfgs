{ pkgs, config, ... }:
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
  programs.mangohud = {
    enable = true;
    package = pkgs.mangohud.override {
      nvidiaSupport = config.nixdots.linux.gpu == "nvidia";
    };
  };
}
