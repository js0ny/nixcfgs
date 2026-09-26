{ pkgs, lib, ... }: {
  home.packages =
    with pkgs;
    [
      # keep-sorted start
      dos2unix
      gron
      hashcat
      httpie
      jless
      jq
      localPkgs.edit-clipboard
      openssl
      pandoc
      ripgrep-all
      yq-go
      # keep-sorted end
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
      readest
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

  js0ny.persist.stores.local.directories = [
    ".config/ticktick"
    ".local/share/com.bilingify.readest"
    ".config/com.bilingify.readest"
  ];

}
