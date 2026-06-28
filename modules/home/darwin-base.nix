{
  config,
  inputs,
  myLib,
  ...
}:
{
  imports = [
    # keep-sorted start

    (myLib.scanPathsRec ../../modules/home/darwin)
    (myLib.scanPathsRec ../../modules/home/programs)
    ../../modules/home/programs/aichat.nix
    ../../modules/home/programs/cherry-studio.nix
    ../../modules/home/programs/karabiner.nix
    ../../modules/home/programs/nix-index.nix
    ../../modules/home/programs/productivity/anki.nix
    ../../modules/home/programs/productivity/obsidian/module.nix
    ../../modules/home/programs/productivity/sdcv.nix
    ../../modules/home/programs/productivity/sioyek/module.nix
    ../../modules/home/programs/protonvpn.nix
    ../../modules/home/programs/shell/direnv.nix
    ../../modules/home/programs/social/telegram.nix
    ../../modules/home/programs/terminals/ghostty.nix
    ../../modules/home/programs/terminals/zellij/module.nix
    ../modules/packages/devtools.nix
    ../modules/packages/gui.nix
    # ../../modules/home/programs/media/mpv.nix
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
