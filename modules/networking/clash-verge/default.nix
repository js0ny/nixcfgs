{
  flake.nixosModules.clash-verge = _: {
    programs.clash-verge = {
      enable = true;
      tunMode = true;
      serviceMode = true;
    };
    home-manager.sharedModules = [
      {
        nixdots.persist.nosnap.home.directories = [
          ".local/share/io.github.clash-verge-rev.clash-verge-rev"
        ];
      }
    ];
  };
}
