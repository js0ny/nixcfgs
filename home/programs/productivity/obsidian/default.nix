{pkgs, ...}: let
in {
  imports = [
    ./vimrc-support.nix
  ];
  programs.obsidian = {
    enable = false;
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
}
