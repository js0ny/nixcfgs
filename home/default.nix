{ ... }:
{
  imports = [
    # keep-sorted start
    ../common/sops.nix
    ../common/styles/home.nix
    ../options
    ./core
    ./devenvs
    ./filetype
    ./options
    ./predefined-programs
    # keep-sorted end
  ];

  misc.shellAliases = {
    ni = "touch";
    cls = "clear";
    py = "nix run 'nixpkgs#python3'";
    # Hide impermanence mounted directories from duf.
    duf = "duf -hide-mp '/etc/*,/var/*,/home/*/*,/home/*/.*'";
  };

}
