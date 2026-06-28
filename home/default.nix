{ ... }:
{
  imports = [
    # keep-sorted start
    ../common/sops.nix
    ../definitions
    ../modules/filetype/home
    ../options
    ./devenvs
    ./options
    # keep-sorted end
  ];

}
