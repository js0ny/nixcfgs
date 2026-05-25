{ pkgs, ... }:
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
    clip = "wl-copy";
    paste = "wl-paste";
  };

  home.packages = [ pkgs.kdePackages.qtstyleplugin-kvantum ];

}
