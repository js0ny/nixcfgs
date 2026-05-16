{ ... }:
{
  imports = [
    ./filetype/linux.nix
    ./impermanence.nix
    ./xremap/spcl.nix
    ./xremap/caps-esc-ctrl.nix
    ./xremap
  ];

  misc.block-desktop-entries = {
    prefixes = [ "waydroid" ];
    desktops = [
      # keep-sorted start
      "howdy"
      "khal"
      "org.fcitx.fcitx5-migrator"
      "org.kde.kwalletmanager"
      "org.kde.qrca"
      "qt6ct"
      "qv4l2"
      "qvidcap"
      "url-dispatcher"
      # keep-sorted end
    ];
  };

  misc.shellAliases = {
    ii = "xdg-open";
    open = "xdg-open";
    clip = "wl-copy";
    paste = "wl-paste";
  };
  # Upstream: stylix: qt: `config.stylix.targets.qt.platform` other than 'qtct' are currently unsupported: kde. Support may be added in the future.
  # stylix.targets.qt.platform = "qtct";
}
