{...}: {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  nixdots.persist.home.directories = [
    ".local/share/direnv"
  ];
}
