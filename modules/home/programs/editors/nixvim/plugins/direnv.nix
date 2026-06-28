{ pkgs, ... }:
{
  programs.nixvim.extraPlugins = [ pkgs.vimPlugins.direnv-vim ];
}
