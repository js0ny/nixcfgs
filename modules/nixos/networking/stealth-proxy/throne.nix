{

  programs.throne = {
    enable = true;
    tunMode.enable = true;
  };

  home-manager.sharedModules = [
    {
      js0ny.persist.stores.local.directories = [ ".config/Throne" ];
    }
  ];
}
