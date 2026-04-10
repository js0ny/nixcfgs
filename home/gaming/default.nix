{ pkgs, ... }:
{
  imports = [
    ./PDS
    ./PDS/hoi4
    ./celeste
    ./emulators/retroarch.nix
    ./emulators/cemu.nix
    ./emulators/ryujinx.nix
    ./slayTheSpire2
    ./steam
    ./minecraft.nix
  ];
  home.packages = with pkgs; [
    lutris
    scanmem
    localPkgs.noname
  ];
}
