{ ... }:
{
  imports = [
    ../options

    ../common/impermanence/home.nix
    ../common/sops.nix
    ../common/styles/home.nix

    ./filetype
    ./programs
    ./services

    ./antidots.nix
    ./core.nix
    ./gpg.nix
    ./do-not-track.nix
    ./sops.nix
    ./gnome-keyrings.nix
    ./shellAliases.nix
    ./mcp.nix
    ./llm.nix
    ./ssh.nix
    ./directories.nix

    ../../helper/mergetools.nix
  ];

}
