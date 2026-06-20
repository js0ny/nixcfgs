{ pkgs, ... }:
{
  home.packages = with pkgs; [
    quickemu
    qemu-utils
  ];
  nixdots.persist.nosnap.home.directories = [
    "VMs"
  ];

}
