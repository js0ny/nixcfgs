_:
let
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
