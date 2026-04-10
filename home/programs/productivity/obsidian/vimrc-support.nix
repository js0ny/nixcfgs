{ ... }:
{
  programs.obsidian.defaultSettings = {
    extraFiles.".obsidian.vimrc" = {
      target = "../.obsidian.vimrc";
      source = ./obsidian.vim;
    };
  };
}
