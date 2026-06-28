{ pkgs, ... }:
let
  dwproton = pkgs.misc.data.proton.dwproton-pin;
in
{
  imports = [
    ../../../modules/programs/gaming/mangohud.nix
    ./wine.nix
  ];
  home.packages = [
    (pkgs.bottles.override {
      removeWarningPopup = true;
    })
  ];

  xdg.dataFile."bottles/runners/dwproton-${dwproton.version}".source = dwproton;
  dconf.settings = {
    "com/usebottles/bottles" = {
      update-date = true;
      startup-view = "page_library";
      show-sandbox-warning = false;
      show-funding = false;
      steam-proton-support = true;
    };
  };

  nixdots.persist.nosnap.home = {
    directories = [
      ".local/share/bottles"
    ];
  };
}
