{
  pkgs,
  lib,
  ...
}:
{
  home.packages =
    with pkgs;
    if pkgs.stdenv.isLinux then
      [
        # keep-sorted start
        bluetui
        dex
        ffmpeg
        imagemagick
        localPkgs.edit-clipboard
        localsend
        # Image Viewer
        loupe # SUPER FAST 有催人跑的感觉 w/ GPU Accel.
        nixpaks.ticktick
        pandoc
        # Theming
        papirus-icon-theme
        proton-pass-cli
        qbittorrent
        qpwgraph
        remmina
        ripdrag
        ripgrep-all
        showmethekey
        signal-desktop
        siyuan
        trash-cli
        # keep-sorted end
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
      "ticktick"
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
  home.sessionVariables = lib.optionalAttrs (pkgs.stdenv.isLinux) {
    PROTON_PASS_LINUX_KEYRING = "dbus";
  };
}
