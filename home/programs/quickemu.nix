{ pkgs, ... }:
{
  home.packages = with pkgs; [
    quickemu
  ];
  nixdots.persist.nosnap.home.directories = [
    "VMs"
  ];

}
