{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    interactiveShellInit = import ./zsh-system-init.nix { inherit pkgs lib inputs; };
  };
  environment.pathsToLink = [ "/share/zsh" ]; # completion
}
