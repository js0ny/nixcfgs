{ pkgs, lib, ... }: {
  home.packages =
    with pkgs;
    [
      ripgrep-all
      localPkgs.edit-clipboard
      pandoc
      dos2unix
      gron
      httpie
      jless
      jq
      yq-go
    ]
    ++ ((lib.optionals pkgs.stdenv.hostPlatform.isLinux) [
      # keep-sorted start
      bluetui
      dex
      ffmpeg
      imagemagick
      kdePackages.ark
      # Image Viewer
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
    ++ ((lib.optionals pkgs.stdenv.hostPlatform.isDarwin) [
      # keep-sorted start
      betterdisplay
      macism # swift-native im-select alternative
      orbstack
      # keep-sorted end
    ]);

  js0ny.homebrew = {
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

  home.sessionVariables = lib.optionalAttrs (pkgs.stdenv.hostPlatform.isLinux) {
    PROTON_PASS_LINUX_KEYRING = "dbus";
  };

  nixdots.persist.nosnap.home.directories = [ ".config/ticktick" ];
}
