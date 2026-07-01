{ inputs, myLib, ... }:
{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
    inputs.self.homeModules.core
    # keep-sorted start
    ../../definitions
    ../options
    ./linux/module.nix
    # keep-sorted end
  ]
  ++ myLib.scanPathsRec ../../modules/options/home;
}
