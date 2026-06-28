{ inputs, myLib, ... }:
{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
    # keep-sorted start
    ./programs
    # keep-sorted end
  ]
  ++ myLib.scanPathsRec ../../modules/home/linux;
}
