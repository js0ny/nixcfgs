{
  pkgs,
  lib,
  ...
}: let
in {
  imports = [
    ./vimrc-support.nix
    ./vim-im-select.nix
  ];
  programs.obsidian = {
    enable = false;
    cli.enable = true;
    vaults."HomeManagerDryRun" = {
      enable = true;
      target = "HomeManagerDryRun"; # relative to $HOME
      settings = {
      };
    };
  };
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
