{...}: {
  programs.carapace = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
    # carapace works bad for fish
    enableFishIntegration = false;
    enableNushellIntegration = false;
  };
}
