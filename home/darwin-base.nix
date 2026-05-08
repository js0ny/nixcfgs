{ config, ... }:
{
  imports = [
    # keep-sorted start

    # ./programs/media/mpv.nix

    ../modules/home
    ../modules/home/darwin.nix
    ./packages/devtools.nix
    ./packages/gui.nix
    ./programs
    ./programs/aichat.nix
    ./programs/browsers/firefox
    ./programs/cherry-studio.nix
    ./programs/darwin
    ./programs/editors/nvim
    ./programs/nix-index.nix
    ./programs/opencode
    ./programs/productivity/anki.nix
    ./programs/productivity/obsidian
    ./programs/productivity/sdcv.nix
    ./programs/productivity/sioyek
    ./programs/rime
    ./programs/shell/bash.nix
    ./programs/shell/direnv.nix
    ./programs/shell/fish
    ./programs/shell/nu.nix
    ./programs/shell/zsh.nix
    ./programs/social/discord.nix
    ./programs/social/telegram.nix
    ./programs/terminals/ghostty.nix
    ./programs/terminals/kitty.nix
    ./programs/terminals/tmux.nix
    ./programs/terminals/zellij.nix
    # keep-sorted end
  ];

  programs.pdf2zh.enable = true;

  nixdefs = {
    acp.enable = true;
    llm.enable = true;
    mcp.enable = true;
    hardware.enable = false;
  };

}
