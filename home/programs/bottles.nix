{ pkgs, ... }:
{
  home.packages = [
    (pkgs.bottles.override {
      removeWarningPopup = true;
    })
  ];
  services.flatpak.packages = [
    "org.freedesktop.Platform.VulkanLayer.MangoHud"
    "org.freedesktop.Platform.VulkanLayer.vkBasalt"
  ];
  dconf.settings = {
    "com/usebottles/bottles" = {
      update-date = true;
      startup-view = "page_library";
    };
  };

  nixdots.persist.nosnap.home = {
    directories = [
      ".local/share/bottles"
    ];
  };
}
