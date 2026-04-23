{ config, ... }:
{
  imports = [
    ../modules/home
    ../modules/home/darwin.nix
    ./packages/devtools.nix
    ./programs

    ./programs/opencode

    ./programs/darwin

    ./programs/rime

    ./programs/browsers/firefox

    ./programs/editors/nvim

    # ./programs/media/mpv.nix

    ./programs/terminals/kitty.nix
    ./programs/terminals/tmux.nix
    ./programs/terminals/ghostty.nix
    ./programs/terminals/zellij.nix

    ./programs/shell/bash.nix
    ./programs/shell/zsh.nix
    ./programs/shell/nu.nix
    ./programs/shell/fish
    ./programs/shell/direnv.nix

    ./programs/social/telegram.nix

    ./programs/aichat.nix
    ./programs/nix-index.nix

    ./programs/productivity/obsidian
    ./programs/productivity/sioyek
    ./programs/productivity/anki.nix
    ./programs/productivity/sdcv.nix
  ];

  programs.pdf2zh.enable = true;

  nixdefs = {
    acp.enable = true;
    llm.enable = true;
    mcp.enable = true;
    hardware.enable = false;
  };
}
