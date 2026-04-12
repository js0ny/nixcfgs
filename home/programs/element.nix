{ pkgs, ... }:
{
  nixdots.persist.home = {
    directories = [
      ".config/Element"
    ];
  };
  home.packages = with pkgs; [
    element-desktop
  ];
}
