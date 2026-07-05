{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkMerge [
  (lib.mkIf pkgs.stdenv.isDarwin {
    targets.genericLinux.enable = false;
    xdg.desktopEntries = lib.mkForce { };
    i18n.inputMethod.enable = false;
    systemd.user.tmpfiles.rules = lib.mkForce [ ];
    targets.darwin = {
      linkApps.enable = true;
    };
  })
  ((lib.mkIf (pkgs.stdenv.isLinux && config.nixdots.linux.nixos)) {
    targets.darwin = lib.mkForce { };
    targets.genericLinux.enable = false;
    launchd.enable = false;
  })
]
