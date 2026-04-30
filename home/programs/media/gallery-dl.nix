{ config, lib, ... }:
let
  xdgDirs = config.xdg.userDirs;
in
{
  programs.gallery-dl = {
    enable = true;
    settings = {
      extractor = {
        base-directory = lib.mkDefault xdgDirs.download;
      };
    };
  };
}
