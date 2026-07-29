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
    inputs.sops-nix.homeManagerModules.sops
    ./vars.nix
    ../../definitions
  ];

  nixdefs.mcp.enable = true;

  home.stateVersion = "26.05";
}
