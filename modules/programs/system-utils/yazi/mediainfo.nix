{
  programs.yazi.settings.plugin = {

    prepend_preloaders = [
      {
        mime = "application/{subrip,postscript,illustrator,dvb.ait,vnd.adobe.illustrator,eps}";
        run = "mediainfo";
      }
      {
        mime = "image/x-eps";
        run = "mediainfo";
      }
      {
        url = "*.{ai,eps,ait}";
        run = "mediainfo";
      }
      {
        mime = "audio/*";
        run = "mediainfo";
      }
      {
        mime = "image/*";
        run = "mediainfo --no-metadata";
      }
      {
        mime = "video/*";
        run = "mediainfo --no-preview";
      }
    ];
    prepend_previewers = [

      {
        mime = "{audio,video,image}/*";
        run = "mediainfo";
      }
      {
        mime = "application/subrip";
        run = "mediainfo";
      }

      # Adobe Illustrator & Postscript
      {
        mime = "application/postscript";
        run = "mediainfo";
      }
      {
        mime = "application/illustrator";
        run = "mediainfo";
      }
      {
        mime = "application/dvb.ait";
        run = "mediainfo";
      }
      {
        mime = "application/vnd.adobe.illustrator";
        run = "mediainfo";
      }
      {
        mime = "image/x-eps";
        run = "mediainfo";
      }
      {
        mime = "application/eps";
        run = "mediainfo";
      }

      # Extension fallback for AI files
      {
        url = "*.{ai,eps,ait}";
        run = "mediainfo";
      }

      # Specific flags
      # {
      #   mime = "{image}/*";
      #   run = "mediainfo --no-metadata";
      # }
      {
        mime = "{video}/*";
        run = "mediainfo --no-preview";
      }
    ];
  };
}
