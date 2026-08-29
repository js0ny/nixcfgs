{
  inputs,
  myLib,
  config,
  ...
}:
{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
    # keep-sorted start
    ../../../../definitions
    ../../../../modules/home/linux/module.nix
    ../../../../modules/options
    # keep-sorted end
  ]
  ++ myLib.scanPathsRec ../../../../modules/options/home;
}
