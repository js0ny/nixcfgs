{ ... }:
{
  imports = [
    # keep-sorted start

    # Packages
    ../packages/cli.nix
    ./bat.nix
    # Editors
    ./editors/vim
    # Utilities & misc
    # ./xilinx.nix
    ./fzf.nix
    ./git.nix
    ./libvirt.nix
    # General Program config (Shared)
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
