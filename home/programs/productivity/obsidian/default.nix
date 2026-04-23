{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    (obsidian.override {
      commandLineArgs = "--password-store=gnome-libsecret";
      electron = pkgs.electron_39;
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
  nixdots.persist.home = {
    directories = [
      ".config/obsidian"
    ];
  };
}
