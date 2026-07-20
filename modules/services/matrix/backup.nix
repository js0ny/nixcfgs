{
  lib,
  pkgs,
  ...
}:
let
  backupDir = "/persist/backups/tuwunel";
  stateDir = "/persist/var/lib/tuwunel";
  systemctl = lib.getExe' pkgs.systemd "systemctl";
  tar = lib.getExe pkgs.gnutar;
  zstd = lib.getExe pkgs.zstd;
  date = lib.getExe' pkgs.coreutils "date";
  chmod = lib.getExe' pkgs.coreutils "chmod";
  install = lib.getExe' pkgs.coreutils "install";
  mv = lib.getExe' pkgs.coreutils "mv";
  rm = lib.getExe' pkgs.coreutils "rm";
  backup = pkgs.writeShellScript "tuwunel-backup" /* bash */ ''
    set -euo pipefail

    stamp="$(${date} +%Y%m%d-%H%M%S)"
    archive="${backupDir}/tuwunel-$stamp.tar.zst"
    temporary="$archive.tmp"
    was_active=false

    cleanup() {
      status=$?
      trap - EXIT
      ${rm} -f "$temporary"

      if [[ "$was_active" == true ]] && ! ${systemctl} start tuwunel.service; then
        status=1
      fi

      exit "$status"
    }
    trap cleanup EXIT

    ${install} -d -m 0700 ${backupDir}

    if ${systemctl} is-active --quiet tuwunel.service; then
      was_active=true
      ${systemctl} stop tuwunel.service
    fi

    ${tar} \
      --acls \
      --xattrs \
      --numeric-owner \
      -I '${zstd} -T0 -10' \
      -C ${dirOf stateDir} \
      -cf "$temporary" \
      ${baseNameOf stateDir}

    ${zstd} -t "$temporary"
    ${chmod} 0600 "$temporary"
    ${mv} "$temporary" "$archive"

    printf 'Backup created: %s\n' "$archive"
  '';
in
{
  systemd.services.tuwunel-backup = {
    description = "Back up the Tuwunel database and media";
    after = [ "local-fs.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = backup;
      TimeoutStartSec = "2h";
      UMask = "0077";
      Nice = 10;
      IOSchedulingClass = "idle";
    };
  };
}
