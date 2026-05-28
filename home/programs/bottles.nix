{ pkgs, ... }:
{
  # Upstream: https://nixpk.gs/pr-tracker.html?pr=511730
  # home.packages = [
  #   (pkgs.bottles.override {
  #     removeWarningPopup = true;
  #   })
  # ];
  services.flatpak.packages = [
    "com.usebottles.bottles"
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
