{ pkgs, lib, ... }: {
  services.sing-box.enable = true;
  systemd.tmpfiles.rules = [
    "L+ /var/lib/sing-box/dashboard - - - - ${pkgs.sing-box-dashboard}"
  ];
  js0ny.persist.stores.state.files = [
    {
      file = "/etc/sing-box/config.json";
      how = "symlink";
    }
  ];
  systemd.services.sing-box.wantedBy = lib.mkForce [ ];
  js0ny.user.groups = [ "sing-box" ];
}
