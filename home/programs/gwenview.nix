{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs.kdePackages; [
    gwenview
  ];

  mergetools.gwenviewConfig = {
    target = "${config.home.homeDirectory}/.config/gwenviewrc";
    format = "ini";
    settings = {
      ImageView = {
        AnimationMethod = "DocumentView::NoAnimation";
        MouseWheelBehavior = "MouseWheelBehavior::Browse";
        NavigationEndNotification = "NavigationEndNotification::AlwaysWarn";
      };
    };
  };
  nixdots.persist.home = {
    directories = [
      ".local/share/kxmlgui5/gwenview"
    ];
  };
}
