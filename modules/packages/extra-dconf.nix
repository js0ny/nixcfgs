{ config, ... }: {
  # https://docs.gtk.org/gio/class.Settings.html
  dconf.settings = {
    "moe/tsukimi" = {
      auto-skip-intro-outro = true;
      is-auto-select-server = true;
      is-overlay = false;
      is-refresh = false;
      item-card-style = "separated";
      mpv-audio-preferred-lang = 2; # 0: None, 1: English, 2: Chinese, 3: Japanese
      mpv-hwdec = 0;
      mpv-show-buffer-speed = true;
      mpv-subtitle-font = "Normal";
      mpv-subtitle-preferred-lang = 2; # 0: None, 1: English, 2: Chinese, 3: Japanese
      music-repeat-mode = "none";
      root-pic = "${config.home.homeDirectory}/Pictures/20260927_092807.png";
      preferred-server = "Belvedere";
    };

    # nautilus
    "org/gnome/nautilus/list-view" = {
      use-tree-view = true;
    };
    "org/gnome/nautilus/preferences" = {
      show-creat-link = true;
      show-delete-permanently = true;
    };
    "org/gtk/gtk4/settings/file-chooser" = {
      show-hidden = true;
    };
  };
}
