{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    # Game launcher and library manager
    lutris

    # Memory Scanner (Cheat Engine Alt.)
    scanmem

    localPkgs.noname
    cemu
  ];
}
