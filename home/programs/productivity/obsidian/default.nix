{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    obsidian
  ];
  nixdots.persist.home = {
    directories = [
      "Obsidian"
      ".config/obsidian"
    ];
  };
}
