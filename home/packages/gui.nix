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
    ]
    ++ ((lib.optionals pkgs.stdenv.isLinux) [
      # keep-sorted start
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
      vlc
      # keep-sorted end
    ])
    ++ ((lib.optionals pkgs.stdenv.isDarwin) [ ]);

  nixdots.darwin.homebrew = {
    taps = [
      "daipeihust/tap" # im-select
    ];
    formulae = [
      "im-select"
    ];
    casks = [
      "ticktick"
      "proton-drive"
      "localsend"
      "skim" # PDF Reader
      "keka" # GUI Unarchiver
      "orbstack" # Docker runtime
      # System Enhancement
      "karabiner-elements" # Keymapping
      "betterdisplay"
      "scroll-reverser" # Natural scrolling for trackpad only
    ];
  };

  home.sessionVariables = lib.optionalAttrs (pkgs.stdenv.isLinux) {
    PROTON_PASS_LINUX_KEYRING = "dbus";
  };

  nixdots.persist.nosnap.home.directories = [ ".config/ticktick" ];
}
