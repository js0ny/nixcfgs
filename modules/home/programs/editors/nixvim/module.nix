{
  lib,
  myLib,
  inputs,
  ...
}:
{
  imports = [ inputs.nixvim.homeModules.nixvim ]; # ++ myLib.scanPaths ./.;
  programs.nixvim = {
    enable = false;
    viAlias = true;

    globals = {
      mapleader = " ";
      maplocalleader = "\\";
      autoformat = true;
      loaded_perl_provider = 0;
      loaded_ruby_provider = 0;
      loaded_node_provider = 0;
      loaded_python3_provider = 0;
    };
  };

}
