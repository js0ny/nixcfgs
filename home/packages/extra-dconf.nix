{ ... }: {
  dconf.settings = {
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
