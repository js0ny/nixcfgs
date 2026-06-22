{
  pkgs,
  lib,
  ...
}:
{

  home.packages =
    with pkgs;
    [
      ripgrep-all
      proton-pass-cli
      localPkgs.edit-clipboard
      localsend
      pandoc
      mat2
    ]
    ++ ((lib.optionals pkgs.stdenv.isLinux) [
      # keep-sorted start
      metadata-cleaner
      bluetui
      dex
      ffmpeg
      imagemagick
      kdePackages.ark
      # Image Viewer
      loupe # SUPER FAST 有催人跑的感觉
      nixpaks.ticktick
      # Theming
      papirus-icon-theme
      qbittorrent
      qpwgraph
      remmina
      ripdrag
      showmethekey
      signal-desktop
      siyuan
      # keep-sorted end
    ])
    ++ ((lib.optionals pkgs.stdenv.isDarwin) [
      # keep-sorted start
      betterdisplay
      macism # swift-native im-select alternative
      orbstack
      # keep-sorted end
    ]);

  nixdots.darwin.homebrew = {
    taps = [
      # "daipeihust/tap" # im-select
    ];
    formulae = [
      # "daipeihust/tap/im-select"
      "folderify"
    ];
    casks = [
      "ticktick"
      "proton-drive"
    ];
  };

  home.sessionVariables = lib.optionalAttrs (pkgs.stdenv.isLinux) {
    PROTON_PASS_LINUX_KEYRING = "dbus";
  };

  nixdots.persist.nosnap.home.directories = [ ".config/ticktick" ];
}
