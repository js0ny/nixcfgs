{ inputs, myLib, ... }:
{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
    # keep-sorted start
    ../../common/sops.nix
    ../../definitions
    ../../modules/filetype/home.nix
    ../../options
    ./linux/module.nix
    # keep-sorted end
  ]
  ++ myLib.scanPathsRec ../../modules/options/home;
}
