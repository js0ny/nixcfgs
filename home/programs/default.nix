{ ... }:
{
  imports = [
    # keep-sorted start

    ../packages/cli.nix
    ./bat.nix
    ./thunderbird.nix
    ./editors/vim
    ./fastfetch.nix
    ./fzf.nix
    ./git.nix
    ./libvirt.nix
    ./lsd.nix
    ./rtorrent.nix
    # Shell
    ./shell/bash.nix
    ./shell/carapace.nix
    ./shell/fish
    ./starship.nix
    ./terminals/tmux.nix
    ./tldr.nix
    ./yazi
    ./zoxide.nix

    # keep-sorted end
  ];
}
