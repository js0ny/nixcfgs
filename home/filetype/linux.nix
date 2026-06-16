{
  config,
  lib,
  ...
}:
let
  apps = config.nixdots.apps;
  textMimes = [
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
    "text/vnd.trolltech.linguist" # .ts (Qt Translation Source File)
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
    "image/jpeg"
    "image/jpg"
    "image/png"
    "image/gif"
    "image/bmp"
    "image/avif"
    "image/webp"
    "image/x-portable-pixmap"
    "image/svg+xml"
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
      "inode/directory" = toMimeAppList [
        apps.fileManager.gui.desktop
        apps.fileManager.tui.desktop
        "org.gnome.Nautilus"
        "org.kde.dolphin"
        "nemo"
        "yazi"
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
      "org.gnome.Loupe"
      "org.kde.gwenview"
      "swayimg"
      "mpv"
      "umpv"
    ];
  };

}
