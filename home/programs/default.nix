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
    # Shell
    ./shell/bash.nix
    ./shell/carapace.nix
    ./shell/fish
    ./starship.nix
    ./terminals/tmux.nix
    ./thunderbird.nix
    ./yazi

    # keep-sorted end
  ];
}
