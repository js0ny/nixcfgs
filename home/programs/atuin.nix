_: {
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };
  nixdots.persist.home.directories = [ ".local/share/atuin" ];
}
