/* kdl */ ''
  window-rule {
      match app-id="^.*terminal-popup$"
      match app-id="^fsearch$"
      open-floating true
      opacity 0.800000
  }
  window-rule {
      match app-id="^org.gnome.NautilusPreviewer$"
      match app-id="^org.gnome.Nautilus$" title="^Select Document$"
      match app-id="^org.gnome.Settings.GlobalShortcutsProvider$" title="^Add Keyboard Shortcuts$"
      open-floating true
  }
  window-rule {
      match app-id="^org.pulseaudio.pavucontrol$" title="^Volume Control$"
      open-floating true
      opacity 0.800000
      default-floating-position relative-to="top-right" x=50 y=50
  }
  window-rule {
      match app-id="^firefox$" title="^Picture-in-Picture$"
      match title="^Picture in picture$"
      match app-id="^steam$" title="^Recordings & Screenshots$"
      match app-id="^steam$" title="^Friends List$"
      open-floating true
      opacity 0.800000
      default-floating-position relative-to="bottom-right" x=50 y=50
  }
  window-rule {
      match app-id="^mpv$"
      open-floating true
      default-floating-position relative-to="bottom-right" x=50 y=50
  }
  window-rule {
      match app-id="^org.gnome.Loupe$"
      open-floating true
      default-floating-position relative-to="bottom-right" x=50 y=50
  }
  window-rule {
      match app-id="^gimp$" title="^GIMP Startup$"
      match app-id="^wechat$" title="^wechat$"
      open-focused false
  }
  window-rule {
      match app-id="^org.kde.(ark|dolphin)$" title="^Extracting"
      match app-id="^steam$"
      open-focused false
      default-floating-position relative-to="top-right" x=50 y=50
  }
  window-rule {
      match app-id="^anki$" title="^Add$"
      match app-id="^org.kde.dolphin$" title="^(Copying|Compressing).*$"
      match app-id="^thunar$" title="^File Operation Progress$"
      match app-id="^QQ$" title="^图片查看器$"
      match app-id="^QQ$" title="^群聊的聊天记录$"
      match app-id="^org.telegram.desktop$" title="^Media viewer$"
      match app-id="^com.ayugram.desktop$" title="^m|Media viewer$"
      match app-id="^io.github.kukuruzka165.materialgram$" title="^Media viewer$"
      match app-id="^wechat$" title="^图片和视频$"
      match app-id="^CherryStudio$" title="^Cherry Studio Quick Assistant$"
      open-floating true
  }
  window-rule {
      match app-id="^firefox$"
      open-on-workspace "1-master"
  }
  window-rule {
      match app-id="^code$"
      match app-id="^dev.zed.Zed$"
      match app-id="^Vitis IDE$"
      match app-id="^Vivado$"
      open-on-workspace "2-project"
  }
  window-rule {
      match app-id="^org.kde.krdc$"
      match app-id="^org.remmina.Remmina$"
      match app-id="^.virt-manager-wrapped$"
      match title="^🌐 ssh.*"
      open-on-workspace "3-alt"
  }
  window-rule {
      match app-id="^org.telegram.desktop$"
      match app-id="^io.github.kukuruzka165.materialgram$"
      match app-id="^com.ayugram.desktop$"
      match app-id="^wechat$"
      match app-id="^QQ$"
      match app-id="^discord$"
      match app-id="^thunderbird$"
      open-on-workspace "4-info"
  }
  window-rule {
      match app-id="^feishin$"
      match app-id="^Cider$"
      open-on-workspace "5-bg"
  }
''
