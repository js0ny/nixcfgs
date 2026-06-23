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
    ./predefined-programs
    # keep-sorted end
  ];

}
