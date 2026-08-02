{ inputs, ... }:
let
  mod = inputs.self.homeModules;
in
{
  imports = [
    mod.server
    mod.starship
    mod.neovim
    mod.vibe-coding
    mod.modern-unix
    mod.fish
    mod.nix-index-database
    inputs.sops-nix.homeManagerModules.sops
    ./vars.nix
    ../../definitions
  ];

  nixdefs.mcp.enable = true;

  home.stateVersion = "26.05";

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
