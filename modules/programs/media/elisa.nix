{
  pkgs,
  config,
  ...
}:
{
  mergetools.elisarc = {
    target = "${config.home.homeDirectory}/.config/elisarc";
    format = "ini";
    settings = {
      ElisaFileIndexer = {
        "RootPath[$e]" = config.xdg.userDirs.music;
      };
    };
  };
  home.packages = with pkgs.kdePackages; [
    elisa
  ];
  js0ny.persist.stores.state = {
    files = [
      {
        file = ".config/elisarc";
        how = "symlink";
      }
    ];
    directories = [ ".local/share/elisa" ];
  };
}
