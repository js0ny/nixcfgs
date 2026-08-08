{
  config,
  inputs,
  myLib,
  ...
}:
{
  imports = [
    # keep-sorted start

    ../../modules/home/programs/karabiner.nix
    ../options
    # ../../modules/home/programs/media/mpv.nix
    # keep-sorted end
    inputs.secrets.homeManagerModules.default

    inputs.self.homeModules.nix-index-database
    inputs.self.homeModules.anki
    inputs.self.homeModules.obsidian
    inputs.self.homeModules.sdcv
    inputs.self.homeModules.sioyek
    inputs.self.homeModules.protonvpn
    inputs.self.homeModules.telegram
    inputs.self.homeModules.ghostty
    inputs.self.homeModules.zellij
    ./darwin-mock-options.nix
  ]
  ++ myLib.scanPathsRec ../../modules/options/home;
  # ++ (myLib.scanPathsRec ../../modules/home/programs);

  nixdefs = {
    acp.enable = true;
    llm.enable = true;
    mcp.enable = true;
    hardware.enable = false;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

}
