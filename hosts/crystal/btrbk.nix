{ ... }:
{
  services.btrbk.instances.persist = {
    onCalendar = "Wed,Sun *-*-* 03:45:20";
    settings = {
      timestamp_format = "long";

      snapshot_dir = "snapshots";
      snapshot_create = "always";

      snapshot_preserve_min = "2d";
      snapshot_preserve = "7d 4w 2m";

      volume."/btr_pool" = {
        subvolume."persist" = { };
      };
    };
  };
}
