{ ... }:
{
  imports = [
    # keep-sorted start
    ../common/sops.nix
    ../definitions
    ../options
    ./core
    ./devenvs
    ./filetype
    ./options
    # keep-sorted end
  ];

}
