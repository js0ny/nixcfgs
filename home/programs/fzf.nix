{pkgs, ...}: {
  home.packages = with pkgs.localPkgs.fzfScripts; [edit-fzf ii-fzf];
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };
  programs = {
    bash.shellAliases = {
      ef = "edit-fzf";
    };
    zsh.shellAliases = {
      ef = "edit-fzf";
    };
    fish.shellAbbrs = {
      ef = "edit-fzf";
    };
  };
}
