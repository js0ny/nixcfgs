{
  pkgs,
  lib,
  ...
}:
lib.mkIf pkgs.stdenv.isLinux {
  home.packages = with pkgs; [
    gcr
  ];

  services.gnome-keyring.enable = true;
  nixdots.persist.home = {
    directories = [
      ".local/share/keyrings"
    ];
  };
}
