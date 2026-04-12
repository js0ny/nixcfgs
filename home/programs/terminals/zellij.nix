{ ... }:
{
  programs.zellij = {
    enable = true;
  };

  nixdots.programs.shellAliases = {
    zj = "zellij";
  };
}
