{ lib, config, ... }:
let
  shell = config.nixdots.apps.interactiveShell.package;
in
{
  programs.zellij = {
    enable = true;
    settings = {
      default_shell = lib.getExe shell;
      # zellij resurrect will records /nix/store hash, works bad with nix
      session_serialization = false;
    };
    extraConfig = (builtins.readFile ./zellij.kdl);
  };

  misc.shellAliases = {
    zj = "zellij";
  };
  xdg.configFile."zellij/layouts" = {
    source = ./layouts;
    recursive = true;
  };
}
