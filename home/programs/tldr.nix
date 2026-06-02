{ ... }:
{
  programs.tealdeer = {
    enable = true;
    enableAutoUpdates = true;
  };
  nixdots.persist.nosnap.home = {
    directories = [
      ".cache/tealdeer"
    ];
  };
}
