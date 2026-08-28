{
  flake.nixosModules.throne = _: {

    programs.throne = {
      enable = true;
      tunMode.enable = true;
    };

    home-manager.sharedModules = [
      { nixdots.persist.nosnap.home.directories = [ ".config/Throne" ]; }
    ];
  };
}
