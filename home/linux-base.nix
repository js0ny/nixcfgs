{ inputs, ... }:
{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
    # keep-sorted start
    ./linux
    ./programs
    # keep-sorted end
  ];
}
