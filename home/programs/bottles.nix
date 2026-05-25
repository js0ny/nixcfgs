{ pkgs, ... }:
{
  # Upstream: https://github.com/NixOS/nixpkgs/pull/511730
  # home.packages = [
  #   (pkgs.bottles.override {
  #     removeWarningPopup = true;
  #   })
  # ];
  services.flatpak.packages = [ "com.usebottles.bottles" ];
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
