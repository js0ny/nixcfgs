{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  environment.systemPackages = [ pkgs.localPkgs.clipboard-copy ];
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    interactiveShellInit = import ./zsh-system-init.nix { inherit pkgs lib inputs; };
  };
  environment.pathsToLink = [ "/share/zsh" ]; # completion
}
