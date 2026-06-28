{ inputs, ... }:
{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
    # keep-sorted start
    (myLib.scanPathsRec ../../modules/home/programs)
    ./linux
    # keep-sorted end
  ];
}
