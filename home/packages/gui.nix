{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ../../hardening/nixpaks
  ];
  home.packages = with pkgs; [
    asciinema
    visidata
    imagemagick
    ansi2html
    gocryptfs
    uv
    pandoc
    dex
    trash-cli
    # Image Viewer
    loupe # SUPER FAST 有催人跑的感觉 w/ GPU Accel.
    qbittorrent
    nixpaks.qq
    signal-desktop
    # Theming
    papirus-icon-theme
    mission-center
    remmina
    siyuan
    localsend
    proton-vpn
    showmethekey
    localPkgs.edit-clipboard
    bluetui
    newsboat
    openai-whisper
    ripdrag
    qpwgraph
  ];
}
