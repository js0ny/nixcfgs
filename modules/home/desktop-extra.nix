{
  pkgs,
  config,
  secrets,
  myLib,
  ...
}:
{
  imports = [
    # keep-sorted start

    ../../modules/desktop/home/niri/module.nix
    ../../modules/home/programs/bottles.nix
    ../../modules/home/programs/browsers/qutebrowser.nix
    ../../modules/home/programs/cherry-studio.nix
  ]
  ;
}
