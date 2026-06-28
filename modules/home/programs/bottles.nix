{ pkgs, ... }:
let
  dwproton = pkgs.misc.data.proton.dwproton-pin;
in
{
  imports = [
    ../../../modules/programs/gaming/mangohud.nix
  ];
}
