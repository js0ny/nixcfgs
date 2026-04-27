{
  pkgs,
  config,
  ...
}:
let
  # forceElectron39 =
  #   p:
  #   (p.override {
  #     electron = pkgs.electron_39;
  #   });
in
{
  imports = [
    ../../hardening/nixpaks
  ];
  home.packages =
    with pkgs;
    if pkgs.stdenv.isLinux then
      [
        imagemagick
        pandoc
        dex
        trash-cli
        # Image Viewer
        loupe # SUPER FAST 有催人跑的感觉 w/ GPU Accel.
        qbittorrent
        nixpaks.qq
        nixpaks.ticktick
        signal-desktop
        # Theming
        papirus-icon-theme
        remmina
        siyuan
        localsend
        proton-vpn
        showmethekey
        localPkgs.edit-clipboard
        bluetui
        ripdrag
        qpwgraph
      ]
    else
      [ ];
  nixdots.darwin.homebrew = {
    taps = [
      "daipeihust/tap" # im-select
    ];
    formulae = [
      "im-select"
    ];
    casks = [
      "TickTick"
      "protonvpn"
      "proton-drive"
      "rustdesk"
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
}
