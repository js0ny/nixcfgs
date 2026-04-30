{ ... }:
{
  imports = [
    ../options

    ../common/sops.nix
    ../common/styles/home.nix

    ./filetype
    ./programs
    ./services
    ./devenvs

    ./antidots.nix
    ./core.nix
    ./gpg.nix
    ./do-not-track.nix
    ./sops.nix
    ./gnome-keyrings.nix
    ./shellAliases.nix
    ./ssh.nix
    ./directories.nix
    ./customDirs.nix

    ../../helper/mergetools.nix
  ];

}
