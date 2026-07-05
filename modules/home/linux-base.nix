{ inputs, myLib, ... }:
{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
    # keep-sorted start
    ../../definitions
    ../options
    ./linux/module.nix
    # keep-sorted end
  ]
  ++ myLib.scanPathsRec ../../modules/options/home;
}
