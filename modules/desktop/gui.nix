{
  lib,
  config,
  pkgs,
  ...
}:
let
  user = config.nixdots.user.name;
  avatar = config.nixdots.user.avatar;
  flatpak = config.nixdots.features.flatpak;
in
{
  xdg.terminal-exec.enable = true;
  services.gvfs.enable = true;

  # udisks2 is needed for disk management and mounting.
  # If you cannot see external drives in your file manager, enable this.
  services.udisks2.enable = true;
  systemd.tmpfiles.rules = lib.optionals (avatar != null) [
    "L+ /var/lib/AccountsService/icons/${user} - - - - ${avatar}"
  ];
  nixdots.persist.system.directories = [ "/var/lib/AccountsService" ];
  services.flatpak.enable = flatpak.enable;
  stylix.targets.qt.platform = lib.mkForce "kde";

  # https://wiki.nixos.org/wiki/Thumbnails
  environment.pathsToLink = [ "share/thumbnailers" ];
  environment.systemPackages = with pkgs; [
    # Video
    ffmpeg-headless
    ffmpegthumbnailer
    # Image
    gdk-pixbuf
    libheif.bin
    libheif.out
    libavif
    libjxl
    webp-pixbuf-loader
    # 3D Models
    # f3d
  ];

}
