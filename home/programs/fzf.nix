{ pkgs, ... }:
{
  home.packages = with pkgs.localPkgs.fzfScripts; [
    edit-fzf
    ii-fzf
  ];
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };
  nixdots.programs.shellAliases = {
    "ef" = "edit-fzf";
  };
}
