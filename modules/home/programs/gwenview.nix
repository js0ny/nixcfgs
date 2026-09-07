{
  pkgs,
  config,
  ...
}:
{
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

  xdg.dataFile."kxmlgui5/gwenview/gwenview.rc".source = ./gwenview.rc;
}
