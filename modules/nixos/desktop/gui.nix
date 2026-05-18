{ lib, config, ... }:
let
  user = config.nixdots.user.name;
  avatar = config.nixdots.user.avatar;
in
{
  xdg.terminal-exec.enable = true;
  services.gvfs.enable = true;

  # udisks2 is needed for disk management and mounting.
  # If you cannot see external drives in your file manager, enable this.
  services.udisks2.enable = true;
  programs.gnome-disks.enable = true;
  # davfs2 is for WebDAV mounts.
  # NOTE: Upstream: https://github.com/NixOS/nixpkgs/issues/512953
  # services.davfs2.enable = true;
  systemd.tmpfiles.rules = lib.optionals (avatar != null) [
    "L+ /var/lib/AccountsService/icons/${user} - - - - ${avatar}"
  ];
  nixdots.persist.system.directories = [ "/var/lib/AccountsService" ];
  services.flatpak.enable = true;
}
