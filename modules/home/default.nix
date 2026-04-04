{...}: {
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
    ./darwin.nix
    ./gnome-keyrings.nix
    ./shellAliases.nix

    ../../helper/mergetools.nix
  ];
}
