{ myLib, ... }:
{
  imports = [
    # keep-sorted start
    ../common/sops.nix
    ../definitions
    ../modules/filetype/home.nix
    ../options
    ./devenvs
    # keep-sorted end
  ]
  ++ myLib.scanPathsRec ../modules/options/home;

}
