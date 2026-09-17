{ pkgs, ... }: {
  services.sing-box.enable = true;
  systemd.tmpfiles.rules = [
    "L+ /var/lib/sing-box/dashboard - - - - ${pkgs.js0ny.sing-box-dashboard}"
  ];
  js0ny.persist.stores.state.files = [
    {
      file = "/etc/sing-box/config.json";
      how = "symlink";
    }
  ];
}
