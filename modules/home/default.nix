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
    ./gnome-keyring.nix
    ./gocryptfs.nix
    ./gpg.nix
    ./programs
    ./services
    ./shellAliases.nix
    ./sops.nix
    ./ssh.nix
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
