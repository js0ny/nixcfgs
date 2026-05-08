{ ... }:
{
  imports = [
    # keep-sorted start

    ../../helper/makeMutable.nix
    ../../helper/mergetools.nix
    ../common/sops.nix
    ../common/styles/home.nix
    ../options
    ./antidots.nix
    ./core.nix
    ./customDirs.nix
    ./devenvs
    ./directories.nix
    ./do-not-track.nix
    ./filetype
    ./gnome-keyrings.nix
    ./gpg.nix
    ./programs
    ./services
    ./shellAliases.nix
    ./sops.nix
    ./ssh.nix
    # keep-sorted end
  ];

}
