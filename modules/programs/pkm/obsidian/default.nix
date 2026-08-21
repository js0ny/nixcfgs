{
  flake.homeModules.obsidian =
    {
      pkgs,
      lib,
      ...
    }:
    {
      home.packages = (lib.optionals pkgs.stdenv.hostPlatform.isLinux) [
        (pkgs.obsidian.override {
          commandLineArgs =
            if pkgs.stdenv.hostPlatform.isLinux then "--password-store=gnome-libsecret" else "";
        })
      ];
      home.directories."Obsidian" = {
        create = true;
        persist = true;
        backup = true;
        sync = false;
        icon = "folder-violet-obsidian";
        index = true;
        pin = true;
      };
      nixdots.persist.nosnap.home.directories = [ ".config/obsidian" ];
      js0ny.homebrew.casks = [ "obsidian" ];
    };
}
