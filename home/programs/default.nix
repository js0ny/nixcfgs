{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    # Packages
    ../packages/cli.nix

    # Shell
    ./shell/bash.nix
    ./shell/fish.nix
    ./shell/carapace.nix

    # Editors
    ./editors/vim

    ./terminals/tmux.nix

    # Utilities & misc
    # ./xilinx.nix
    ./fzf.nix
    ./gwenview.nix
    ./yazi
    ./libvirt.nix
    ./rtorrent.nix
    ./git.nix
    ./tldr.nix

    # General Program config (Shared)
    ./lsd.nix
    ./starship.nix
    ./zoxide.nix

    # Development setup
    ./devenvs/nix.nix
  ];
}
