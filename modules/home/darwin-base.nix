{
  inputs,
  myLib,
  ...
}:
{
  imports = [
    inputs.secrets.darwinModules.default

    inputs.self.homeModules.nix-index-database
    inputs.self.homeModules.ghostty
    inputs.self.homeModules.kitty

    inputs.self.homeModules.telegram
    inputs.self.homeModules.matrix-element

    inputs.self.homeModules.zellij

    inputs.self.homeModules.editors
    inputs.self.homeModules.emacs
    inputs.self.homeModules.neovide
    inputs.self.homeModules.neovim
    inputs.self.homeModules.vcs-extra
    inputs.self.homeModules.vibe-coding

    inputs.self.homeModules.zed-editor
    inputs.self.homeModules.wakatime

    inputs.self.homeModules.hermes-desktop
    inputs.self.homeModules.aichat
    inputs.self.homeModules.cherry-studio

    inputs.self.homeModules.anki
    inputs.self.homeModules.obsidian

    ../../definitions
    ../options
  ]
  ++ myLib.scanPathsRec ../../modules/options/home;

  nixdefs = {
    acp.enable = true;
    llm.enable = true;
    mcp.enable = true;
    hardware.enable = false;
  };

}
