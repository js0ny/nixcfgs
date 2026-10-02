{
  lib,
  pkgs,
  ...
}:
let
  stateDir = "/var/lib/valheim";
  backupDir = "/persist/backups/valheim";
  systemctl = lib.getExe' pkgs.systemd "systemctl";
  tar = lib.getExe pkgs.gnutar;
  zstd = lib.getExe pkgs.zstd;
  date = lib.getExe' pkgs.coreutils "date";
  install = lib.getExe' pkgs.coreutils "install";
  mv = lib.getExe' pkgs.coreutils "mv";
  rm = lib.getExe' pkgs.coreutils "rm";
  backup = pkgs.writeShellScript "valheim-backup" /* bash */ ''
    set -euo pipefail

    stamp="$(${date} +%Y%m%d-%H%M%S-%N)"
    archive="${backupDir}/valheim-$stamp.tar.zst"
    temporary="$archive.tmp"
    was_active=false

    cleanup() {
      status=$?
      trap - EXIT
      ${rm} -f "$temporary"

      if [[ "$was_active" == true ]] && ! ${systemctl} start podman-valheim.service; then
        status=1
      fi

      exit "$status"
    }
    trap cleanup EXIT

    ${install} -d -m 0700 ${backupDir}

    if ${systemctl} is-active --quiet podman-valheim.service; then
      was_active=true
      ${systemctl} stop podman-valheim.service
    fi

    ${tar} \
      --acls \
      --xattrs \
      --numeric-owner \
      --exclude='config/backups' \
      -I '${zstd} -T0 -10' \
      -C ${stateDir} \
      -cf "$temporary" \
      config

    ${zstd} -t "$temporary"
    ${mv} "$temporary" "$archive"

    printf 'Backup created: %s\n' "$archive"
  '';
in
{
  systemd.services.valheim-backup = {
    description = "Back up the Valheim world and configuration";
    after = [ "local-fs.target" ];
    unitConfig.RequiresMountsFor = [ stateDir backupDir ];
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
