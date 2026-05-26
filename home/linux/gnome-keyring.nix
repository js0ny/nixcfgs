{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkMerge [
  {
    nixdots.persist.home = {
      directories = [
        ".local/share/keyrings"
      ];
    };
  }
  (lib.mkIf (pkgs.stdenv.isLinux && !config.nixdots.linux.nixos) {
    services.gnome-keyring.enable = true;
  })
]
