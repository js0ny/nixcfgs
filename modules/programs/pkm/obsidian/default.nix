{
  flake.homeModules.obsidian =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        (obsidian.override {
          commandLineArgs = if pkgs.stdenv.isLinux then "--password-store=gnome-libsecret" else "";
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

    };
}
