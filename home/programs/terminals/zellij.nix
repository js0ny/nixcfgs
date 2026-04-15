{ lib, config, ... }:
let
  shell = config.nixdots.apps.interactiveShell.package;
in
{
  programs.zellij = {
    enable = true;
    settings = {
      default_shell = lib.getExe shell;
    };
    extraConfig = (builtins.readFile ./zellij.kdl);
  };

  nixdots.programs.shellAliases = {
    zj = "zellij";
  };
}
