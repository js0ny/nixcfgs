{...}: {
  programs.tealdeer = {
    enable = true;
    enableAutoUpdates = true;
  };
  nixdots.persist.home = {
    directories = [
      ".cache/tealdeer"
    ];
  };
}
