_:
let
  # Why using nvim gui:
  #   * when `rga-fzf`: nvim wrapper failed to launch
  #   * nvim wrapper reports error on parsing filename with spaces
  audio = [
    "audio/flac"
    "audio/vnd.wave" # .wav
    "audio/x-vorbis+ogg" # .ogg
  ];
  video = [
    "video/mp4"
    "video/quicktime" # .mov
    "video/x-matroska" # .mkv
    "video/mp2t" # .ts .mts .m2ts
  ];

  # Image Viewer:
  #     gwenview: keyboard driven, high compatibility
  #     loupe: Performance is incredible
  # NOTE:
  # Gwenview cannot open avif images properly
  # See: https://github.com/NixOS/nixpkgs/issues/351863
  audioPlayers = "mpv.desktop;org.kde.elisa";
  mkAssoc =
    app: mimes:
    builtins.listToAttrs (
      map (mime: {
        name = mime;
        value = app;
      }) mimes
    );
in
{
  xdg.mimeApps = {
    enable = true;
    # In Dolphin, middle click to open with 2nd order default app
    defaultApplications =
      mkAssoc "onlyoffice-desktopeditors.desktop" [
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        "application/vnd.openxmlformats-officedocument.presentationml.presentation"
      ]
      # Audio:
      #     music: elisa: fully featured, good cjk support
      #     audio: mpv: simple and fast
      // mkAssoc audioPlayers audio
      # Only use umpv in video mode, only one presents
      # and will fork current process
      // mkAssoc "umpv.desktop" video
      // mkAssoc "thunderbird.desktop" [ "x-scheme-handler/mailto" ]
      // mkAssoc "com.usebottles.bottles.desktop" [
        "x-scheme-handler/bottles"
        "application/x-ms-dos-executable"
        "application/x-msi"
        "application/x-ms-shortcut"
        "application/x-wine-extension-msp"
        "application/x-bat"
        "application/x-mswinurl"
      ]
      // {
        "application/epub+zip" = "com.github.johnfactotum.Foliate.desktop";
        # Loupe does not support dds
        # .dds Microsoft DirectDraw Surface
        "image/x-dds" = "mpv.desktop";
      };
  };
}
