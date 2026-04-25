{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isx86_64 {
  home.packages = [ (pkgs.bottles.override { removeWarningPopup = true; }) ];
  dconf.settings = {
    "com/usebottles/bottles" = {
      update-date = true;
      startup-view = "page_library";
    };
  };

  xdg.dataFile."bottles/runners/${pkgs.localPkgs.dwproton.version}".source = pkgs.localPkgs.dwproton;

  nixdots.persist.home = {
    directories = [
      ".local/share/bottles"
    ];
  };
}
