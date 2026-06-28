{ config, inputs, ... }:
{
  imports = [
    # keep-sorted start

    ../modules/packages/devtools.nix
    ../modules/packages/gui.nix
    # ./programs/media/mpv.nix
    ./darwin
    ./programs
    ./programs/aichat.nix
    ./programs/cherry-studio.nix
    ./programs/darwin
    ./programs/editors/nvim
    ./programs/karabiner.nix
    ./programs/nix-index.nix
    ./programs/productivity/anki.nix
    ./programs/productivity/obsidian
    ./programs/productivity/sdcv.nix
    ./programs/productivity/sioyek
    ./programs/protonvpn.nix
    ./programs/shell/direnv.nix
    ./programs/social/telegram.nix
    ./programs/terminals/ghostty.nix
    ./programs/terminals/zellij
    # keep-sorted end
    inputs.secrets.darwinModules.default
  ];

  programs.pdf2zh.enable = true;

  nixdefs = {
    acp.enable = true;
    llm.enable = true;
    mcp.enable = true;
    hardware.enable = false;
  };

}
