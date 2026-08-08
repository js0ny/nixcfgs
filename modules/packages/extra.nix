{
  pkgs,
  lib,
  pkgsStable,
  ...
}:
let
  font-viewer = pkgs.writeShellScriptBin "font-viewer" ''
    exec ${pkgs.font-manager}/libexec/font-manager/font-viewer "$@"
  '';
  pdf2zh = pkgs.writeShellApplication {
    name = "pdf2zh";
    runtimeInputs = with pkgs; [
      uv
      stdenv.cc
    ];
    text = ''
      uvx --python=cp312 --from pdf2zh-next pdf2zh2 "$@"
    '';
  };
  kdeconnect = pkgs.kdePackages.kdeconnect-kde;
in
{
  imports = [
    ./extra-persist.nix
    ./extra-dconf.nix
  ];

  home.packages = with pkgs; [
    # keep-sorted start
    (darktable.override { withAi = true; })
    ashpd-demo # for portal debug
    awscli2
    blender
    bruno
    bruno-cli
    calibre
    dmg2img
    font-manager
    font-viewer
    fontforge
    gdb
    gh
    gimp
    godot
    godotpcktool
    goldendict-ng
    himalaya
    icoutils
    inkscape
    jetbrains.datagrip
    js0ny.dirstat-rs
    js0ny.limes
    js0ny.proton-drive-cli
    js0ny.ratune
    js0ny.wdotool
    kdePackages.elisa
    kdePackages.isoimagewriter
    kdePackages.kdenlive
    kdePackages.kleopatra
    kdePackages.partitionmanager
    kdePackages.qttools
    kdeconnect
    keepassxc
    krabby
    libguestfs
    mission-center
    motrix-next
    nautilus
    newsflash
    nextcloud-client
    nmap
    octaveFull
    pdf2zh
    pkgsStable.python314Packages.huggingface-hub
    rustscan
    sequoia-sq
    tradingview
    tsukimi
    xournalpp
    # keep-sorted end

    # nix
    nixfmt
    nix-diff
    nix-output-monitor
    nvd
    nix-tree
    deploy-rs
    nurl
    nvfetcher
    npins
    nil
    nixd
    cachix
    alejandra
  ];
  home.sessionVariables = {
    GOLDENDICT_FORCE_WAYLAND = 1;
  };

  programs.yazi.settings.plugin.prepend_previewers = [
    {
      url = "*.pck";
      run = "piper -- ${lib.getExe pkgs.godotpcktool} $1";
    }
  ];
  xdg.autostart.entries = [
    # KDE Connect Tray Icon
    "${kdeconnect}/share/applications/org.kde.kdeconnect.nonplasma.desktop"
  ];
  xdg.configFile."gdb/gdbinit".text = ''
    add-auto-load-safe-path /nix/store/*/lib
  '';

  programs.posting = {
    enable = true;
    package = pkgsStable.posting;
  };
  js0ny.flatpak.packages = [
    "com.rustdesk.RustDesk"
  ];
}
