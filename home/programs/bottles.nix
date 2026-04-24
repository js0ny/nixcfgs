{ pkgs, ... }:
{
  home.packages = [ (pkgs.bottles.override { removeWarningPopup = true; }) ];
  dconf.settings = {
    "com/usebottles/bottles" = {
      update-date = true;
      startup-view = "page_library";
    };
  };

  nixdots.persist.home = {
    directories = [
      ".local/share/bottles"
    ];
  };
}
