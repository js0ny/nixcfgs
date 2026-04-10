{ config, ... }:
let
  dataDir = "${config.xdg.dataHome}/rtorrent";
  user = config.home.username;
in
{
  programs.rtorrent = {
    enable = true;
    extraConfig = ''
      directory.default.set = ${dataDir}/downloads
      session.path.set = ${dataDir}/session
      schedule2 = watch_directory, 5, 5, "load.start=${dataDir}/watch/*.torrent"

      network.port_range.set = 50000-50000
      dht.mode.set = auto
      dht.port.set = 6881
      protocol.pex.set = yes

      network.scgi.open_local = ${dataDir}/socket/rpc.socket
      execute2 = chmod,0777,${dataDir}/socket/rpc.socket

      throttle.min_peers.normal.set = 40
      throttle.max_peers.normal.set = 100
      throttle.max_downloads.global.set = 15
      throttle.max_uploads.global.set = 10
    '';
  };

  systemd.user.tmpfiles.rules = [
    "d ${dataDir} 0700 ${user} users -"
    "d ${dataDir}/downloads 0700 ${user} users -"
    "d ${dataDir}/session 0700 ${user} users -"
    "d ${dataDir}/watch 0700 ${user} users -"
    "d ${dataDir}/socket 0777 ${user} users -"
  ];

  nixdots.persist.home = {
    directories = [
      ".local/share/rtorrent"
    ];
  };
}
