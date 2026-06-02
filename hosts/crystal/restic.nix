{
  config,
  lib,
  pkgs,
  secrets,
  ...
}:
let
  user = config.nixdots.user.name;
  latestPersistSnapshot = "/run/latest-persist-snapshot";
in
{
  sops.secrets.restic_repo_password = { };
  sops.secrets.rclone_conf = {
    sopsFile = secrets + /files/rclone.yaml;
    key = "data";
  };

  systemd.services.restic-backups-main = {
    after = [ "btrbk-persist.service" ];
    wants = [ "btrbk-persist.service" ];

    preStart =
      let
        find = lib.getExe pkgs.findutils;
        sort = lib.getExe' pkgs.coreutils "sort";
        tail = lib.getExe' pkgs.coreutils "tail";
        ln = lib.getExe' pkgs.coreutils "ln";
      in
      /* bash */ ''
        set -euo pipefail

        latest="$(${find} /snapshots -maxdepth 1 -type d -name 'persist.*' | ${sort} | ${tail} -n1)"

        if [ -z "$latest" ]; then
          echo "no btrbk snapshot found under /snapshots" >&2
          exit 1
        fi

        ${ln} -sfn "$latest" ${latestPersistSnapshot}
      '';
  };

  services.restic.backups = {
    main = {
      repository = "rclone:distill/crystal";
      rcloneConfigFile = config.sops.secrets.rclone_conf.path;
      passwordFile = config.sops.secrets.restic_repo_password.path;
      initialize = true;

      paths = [
        "${latestPersistSnapshot}/home/${user}/Obsidian"
        "${latestPersistSnapshot}/home/${user}/Academia"
        "${latestPersistSnapshot}/home/${user}/Atelier"

        "${latestPersistSnapshot}/home/${user}/.ssh"
        "${latestPersistSnapshot}/home/${user}/.local/share/gnupg"
        "${latestPersistSnapshot}/home/${user}/.local/share/password-store"
        "${latestPersistSnapshot}/home/${user}/.local/share/keyrings"
      ];

      exclude = [
        "**/node_modules"
        "**/.venv"
        "**/__pycache__"
        "**/target"
        "**/build"
        "**/out"
        "**/.gradle"
        "**/.pnpm-store"

        "**/.clangd"
        "**/.ccls-cache"
        "**/.ipynb_checkpoints"

        "**/.Trash-*"
        "**/Trash"

        "**/.cache"
        "**/Cache"
        "**/Code Cache"
        "**/GPUCache"
        "**/DawnCache"
        "**/ShaderCache"
        "**/GrShaderCache"
        "**/Crashpad"
        "**/logs"
        "**/Service Worker/CacheStorage"

        ".direnv"
        "result"
        "result-*"
      ];

      extraBackupArgs = [
        "--exclude-if-present=.nobackup"
        "--exclude-caches"
        "--one-file-system"
      ];

      timerConfig = {
        OnCalendar = "Wed,Sun *-*-* 04:30:00";
        Persistent = true;
        RandomizedDelaySec = "30m";
      };

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 6"
        "--keep-yearly 2"
      ];
    };
  };
}
