{...}: {
  homebrew = {
    enable = true;
    # Get it via `brew --prefix`
    prefix = "/opt/homebrew";
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };
}
