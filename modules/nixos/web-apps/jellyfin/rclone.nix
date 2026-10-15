{ ... }:

{
  systemd.services.jellyfin.after = [
    "rclone-mount-anime.service"
    "rclone-mount-tvseries.service"
    "rclone-mount-videos.service"
  ];

  js0ny.rclone.mounts = {
    anime = {
      remote = "library:Anime";
      mountPoint = "/mnt/anime";
      mountPointGroup = "users";
      settings.allow-non-empty = true;
    };
    tvseries = {
      remote = "library:Series";
      mountPoint = "/mnt/tvseries";
      mountPointGroup = "users";
      settings.allow-non-empty = true;
    };
    videos = {
      remote = "library:Videos";
      mountPoint = "/mnt/videos";
      mountPointGroup = "users";
      settings.allow-non-empty = true;
    };
  };
}
