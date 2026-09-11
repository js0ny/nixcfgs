{
  lib,
  osConfig,
  ...
}:
{
  imports = [
    ./xremap/spcl.nix
    ./xremap/caps-esc-ctrl.nix
    ./xremap/module.nix
  ];

  misc.block-desktop-entries = {
    prefixes = [ "waydroid" ];
    desktops = [
      # keep-sorted start
      "calibre-lrfviewer"
      "himalaya"
      "howdy"
      "khal"
      "openlogi"
      "org.fcitx.fcitx5-migrator"
      "org.kde.kdeconnect.nonplasma" # KDE Connect Indicator
      "org.kde.kwalletmanager"
      "org.kde.qrca"
      "qt6ct"
      "qv4l2"
      "qvidcap"
      "url-dispatcher"
      "uuctl"
      # keep-sorted end
    ];
  };

  misc.shellAliases = {
    ii = "xdg-open";
    clip = "wl-copy";
    paste = "wl-paste";
  };

  misc.mergetoolsBackend = "systemd";
  home.sessionVariables = lib.mkIf (osConfig.hardware.graphics.enable) {
    NH_ELEVATION_STRATEGY = "run0";
  };
  xdg.dataFile."Templates".source = ./dirs/Templates;
}
