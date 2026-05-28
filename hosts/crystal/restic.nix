{ config, ... }:
let
  homeDir = config.nixdots.user.home;
in
{
  sops.secrets.restic_repo_password = { };

  services.restic.backups = {
    main = {
      # Rclone remote path - using a non-top-level directory
      repository = "rclone:pcloud:Distill/crystal";

      # Use the user's rclone config file since the service runs as root
      rcloneConfigFile = "${homeDir}/.config/rclone/rclone.conf";

      # Password file from sops
      passwordFile = config.sops.secrets.restic_repo_password.path;

      # Directories to back up
      paths = [
        "${homeDir}/Obsidian"
        "${homeDir}/Academia"
      ];

      # Exclude patterns
      exclude = [
        "**/node_modules"
        "**/.venv"
        "**/__pycache__"
        "**/target"
        "**/build"
        "**/out"
        "**/.gradle"
        "**/.Trash-1000"
        "**/.Trash-0"
        "**/.pnpm-store"

        "**/.clangd"
        "**/.ccls-cache"
        "**/.ipynb_checkpoints"

        ".cache"
        ".local/share/Trash"
        ".direnv"
        "result"
      ];

      # Backup schedule (default: daily at 3am)
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true; # Run missed backups after sleep/shutdown
        RandomizedDelaySec = "1h";
      };

      # Automatic snapshot pruning
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 6"
        "--keep-yearly 2"
      ];

      extraOptions = [
        "--exclude-if-present=.nobackup"
        "--exclude-caches"
      ];
    };
  };
}
