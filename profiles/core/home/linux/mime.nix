# TODO: Use NixOS Modules
{
  config,
  pkgs,
  lib,
  ...
}:
let
  apps = config.js0ny.apps;
  textMimes = [
    "text/*"
    "text/plain"
    "text/x-csrc" # .c
    "text/x-chdr" # .h
    "text/javascript"
    "text/typescript"
    "text/x-python"
    "application/yaml" # .yaml, .yml
    "text/x-patch" # .patch .diff
    "text/x-devicetree-source" # .dts
    "text/x-nix" # .nix
    "text/x-pdx-descriptor" # .mod
    "text/csv"
    "text/markdown"
    "text/log" # .log
    "application/vnd.kde.kxmlguirc"
    "application/atom+xml" # .atom
    "application/xml"
    "application/x-shellscript"
    "text/rust"
    "text/x-go"
    "application/x-zerosize" # empty file
    "text/vnd.trolltech.linguist" # .ts (Qt Translation Source File)
    "text/x-typst"
  ];
  webpageMimes = [
    "text/html"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
  ];
  archiveMimes = [
    "application/zip"
    "application/x-rar"
    "application/x-7z-compressed"
    "application/x-tar"
    "application/x-zstd-compressed-tar" # .tar.zst
  ];
  imageMimes = [
    "image/*"
    "image/jpeg"
    "image/jpg"
    "image/png"
    "image/gif"
    "image/bmp"
    "image/avif"
    "image/webp"
    "image/x-portable-pixmap"
    "image/svg+xml"
    "image/tiff"
  ];
  videoMimes = [
    "video/*"
    "video/mp4"
    "video/quicktime" # .mov
    "video/x-matroska" # .mkv
    "video/mp2t" # .ts .mts .m2ts
    "video/x-flv"
    "video/vnd.avi"
  ];
  audioMimes = [
    "audio/*"
    "audio/flac"
    "audio/vnd.wave" # .wav
    "audio/x-vorbis+ogg" # .ogg
  ];
  officeMimes = [
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    "application/vnd.openxmlformats-officedocument.presentationml.presentation"
  ];
  wineMimes = [
    "application/x-ms-dos-executable"
    "application/x-msi"
    "application/x-ms-shortcut"
    "application/x-wine-extension-msp"
    "application/x-bat"
    "application/x-mswinurl"
  ];
  mkAssoc =
    mimes: apps:
    builtins.listToAttrs (
      map (mime: {
        name = mime;
        value = toMimeAppList apps;
      }) mimes
    );
  _appendDesktop = app: if !lib.hasSuffix ".desktop" app then "${app}.desktop" else app;
  toMimeAppList = l: lib.concatStringsSep ";" (lib.unique (map (app: _appendDesktop app) l));
in
{

  xdg.dataFile."mime/packages" = {
    source = ../../filetype/mimepkgs;
    recursive = true;
  };

  home.activation.updateMimeDatabase = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${lib.getExe pkgs.shared-mime-info} "${config.xdg.dataHome}/mime"
  '';
  home.sessionVariables.TERMINAL = "xdg-terminal-exec";
  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [
        apps.terminal.desktop
      ];
    };
  };
  xdg.configFile."mimeapps.list".force = true;
  xdg.mime.enable = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/mailto" = toMimeAppList [ "thunderbird.desktop" ];
      "inode/directory" = toMimeAppList [
        apps.fileManager.gui.desktop
        "org.kde.dolphin"
        "org.gnome.Nautilus"
        apps.fileManager.tui.desktop
        "yazi"
        "nemo"
        "kitty-open"
        "dev.zed.Zed"
        "org.kde.gwenview"
        "org.kde.kid3"
      ];
      "application/pdf" = toMimeAppList [
        "sioyek"
        "org.kde.okular"
        "org.gnome.Papers"
        "calibre-gui"
      ];
      "application/x-bittorrent" = toMimeAppList [
        "org.qbittorrent.qBittorrent"
        "qbittorrent"
        "transmission-gtk"
        "transmission-qt"
        "MotrixNext"
      ];
      # Loupe does not support dds
      # .dds Microsoft DirectDraw Surface
      "image/x-dds" = "mpv.desktop";
      # *.asc mimepkgs/electronics.xml
      # aim to remove ambiguity with openpgp
      "application/x-ltspice-schematic" = "ltspice.desktop";
      "application/pgp-keys" = toMimeAppList [
        "org.kde.kleopatra.desktop"
        apps.editor.gui.desktop
      ];
    }
    // mkAssoc textMimes [ apps.editor.gui.desktop ]
    // mkAssoc webpageMimes [
      "url-dispatcher"
      apps.browser.desktop
      "chromium-browser"
      "org.mozilla.firefox"
      "firefox"
      "helium"
    ]
    // mkAssoc archiveMimes [
      "org.gnome.FileRoller"
      "org.kde.ark"
      "peazip"
      "org.prismlauncher.PrismLauncher"
    ]
    // mkAssoc imageMimes [
      "swayimg"
      "org.gnome.Loupe"
      "org.kde.gwenview"
      "mpv"
      "umpv"
    ]
    # Only use umpv in video mode, only one presents
    # and will fork current process
    // mkAssoc videoMimes [
      "umpv"
      "io.github.diegopvlk.Cine" # gstreamer fallback
    ]
    # Audio:
    #     music: elisa: fully featured, good cjk support
    #     audio: mpv: simple and fast
    // mkAssoc audioMimes [
      "mpv"
      "org.kde.elisa"
      "io.bassi.Amberol"
    ]
    // mkAssoc officeMimes [
      "onlyoffice-desktopeditors.desktop"
    ]
    // mkAssoc wineMimes [
      "com.usebottles.bottles.desktop"
    ];
  };
}
