{ pkgs, ... }:
{
  imports = [
    ../gaming/mangohud.nix
  ];
  home.packages = [
    (pkgs.bottles.override {
      removeWarningPopup = true;
    })
  ];
  dconf.settings = {
    "com/usebottles/bottles" = {
      update-date = true;
      startup-view = "page_library";
      show-sandbox-warning = false;
    };
  };

  nixdots.persist.nosnap.home = {
    directories = [
      ".local/share/bottles"
    ];
  };
}
