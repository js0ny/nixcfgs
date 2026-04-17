{ pkgs, ... }:
{
  nixdots.persist.home = {
    directories = [
      ".config/Element"
    ];
  };
  home.packages = with pkgs; [
    (element-desktop.override {
      commandLineArgs = "--password-store=gnome-libsecret";
    })
  ];
}
