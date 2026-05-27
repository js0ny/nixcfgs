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
  nixdots.persist.home = {
    files = [
      ".config/elisarc"
    ];
    directories = [
      ".local/share/elisa"
    ];
  };
}
