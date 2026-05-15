{ pkgs, ... }:
{
  home.packages = with pkgs; [
    quickemu
  ];
  nixdots.persist.home = {
    directories = [
      "VMs"
    ];
  };
}
