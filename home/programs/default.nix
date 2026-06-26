{ ... }:
{
  imports = [
    # keep-sorted start

    ../packages/cli.nix
    ./editors/vim
    ./fastfetch.nix
    ./git.nix
    ./iina.nix
    ./libvirt.nix
    ./modern-unix
    ./obs-studio.nix
    ./onlyoffice.nix
    ./rtorrent.nix
    ./shell/carapace.nix
    ./starship.nix
    ./terminals/tmux.nix
    ./yazi

    # keep-sorted end
  ];
}
