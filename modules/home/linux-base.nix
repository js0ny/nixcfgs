{ inputs, myLib, ... }:
{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
    # keep-sorted start
    ../../common/sops.nix
    ../../definitions
    ../../modules/filetype/home.nix
    ../../options
    # keep-sorted end
  ]
  ++ myLib.scanPathsRec ../../modules/devenvs
  ++ myLib.scanPathsRec ../../modules/options/home
  ++ myLib.scanPathsRec ./programs
  ++ myLib.scanPathsRec ./linux;
}
