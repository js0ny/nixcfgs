{ pkgs, lib, ... }:
{
  programs.nixvim = {
    plugins.typst-preview = {
      enable = true;
      settings = {
        dependencies_bin = {
          tinymist = lib.getExe pkgs.tinymist;
          websocat = lib.getExe pkgs.websocat;
        };
      };
    };
    extraPackages = with pkgs; [
      tinymist
      websocat
    ];
  };
}
