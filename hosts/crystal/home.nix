{
  pkgs,
  config,
  inputs,
  secrets,
  ...
}:
{
  imports = [
    ./vars.nix
    ../../home/desktop-extra.nix
    ../../home/desktop/hyprland
    # keep-sorted start

    # keep-sorted end

    # keep-sorted start
    inputs.betterfox-nix.modules.homeManager.betterfox
    inputs.catppuccin.homeModules.catppuccin
    inputs.niri-flake.homeModules.niri
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    inputs.nix-index-database.homeModules.nix-index
    inputs.plasma-manager.homeModules.plasma-manager
    inputs.secrets.homeManagerModules.default
    inputs.sops-nix.homeManagerModules.sops
    inputs.spicetify-nix.homeManagerModules.spicetify
    inputs.steam-config-nix.homeModules.default
    # keep-sorted end
  ];

  home.sessionVariables = {
    TO_AV1_CRF = "32";
    TO_AV1_PRESET = "8";
    TO_AV1_MP4_CRF = "32";
    TO_AV1_MP4_PRESET = "8";
    TO_AV1_MP4_AUDIO_BITRATE = "192k";
    TO_AVIF_QUALITY = "85";
    TO_WEBP_QUALITY = "85";
  };

  sops.secrets = {
    gocryptfs_password = {
      sopsFile = secrets + /hosts/crystal.yaml;
    };
    rclone-conf = {
      sopsFile = secrets + /files/rclone.yaml;
      path = "${config.xdg.configHome}/rclone/rclone.conf";
      key = "data";
      mode = "0600";
    };
  };

  home.stateVersion = "25.05";

  home.directories = {

    "Atelier" = {
      create = true; # via systemd.tmpfiles
      persist = true; # via home.impermanence
      backup = true; # via restic
      backupExclude = [
        "dot"
        "oss"
        "src"
      ];
      sync = false; # via rclone
      pin = true; # via gtk bookmarks
      icon = "folder-documents";
      index = true;
    };
    "Academia" = {
      create = true;
      persist = true;
      backup = true;
      pin = true;
      icon = "folder-documents";
      index = true;
    };
    "Downloads" = {
      create = true;
      persist = false;
      backup = false;
      sync = false;
      pin = true;
      icon = "folder-downloads";
    };
    "Music" = {
      create = true;
      backup = false;
      sync = true;
      icon = "folder-music";
      # remote = "pcloud:Library/Music";
    };
    "Pictures" = {
      create = true;
      backup = false;
      sync = false;
      icon = "folder-pictures";
    };
    "Videos" = {
      create = true;
      backup = false;
      sync = false;
      icon = "folder-videos";
    };
    "Documents" = {
      create = true;
      persist = true;
      backup = false;
      sync = false;
      icon = "folder-documents";
    };
  };

  home.customDirs = {
    wallpaper = "${config.home.homeDirectory}/Wallpaper";
    screenshots = "${config.xdg.cacheHome}/Captures/Screenshots";
    screencasts = "${config.xdg.cacheHome}/Captures/Screencasts";
  };
  xdg.autostart = {
    enable = true;
    entries = [
      "${pkgs.nixpaks.materialgram}/share/applications/io.github.kukuruzka165.materialgram.desktop"
      "${pkgs.localPkgs.wechat-bwrap}/share/applications/wechat.desktop"
    ];
  };
  mergetools.ticktick-json = {
    target = "${config.xdg.configHome}/ticktick/config.json";
    format = "json";
    settings = {
      locale = "zh_CN";
      "undefined/theme" = "night";
      "undefined/layoutStyle" = "card";
    };
  };

  programs.gocryptfs = {
    enable = true;
    encryptedDir = ".local/share/Vault.enc";
    mountPoint = ".local/mnt/Vault";
    autoMount = {
      enable = true;
      passwordFile = config.sops.secrets.gocryptfs_password.path;
    };
  };

  nixdots.persist.home.directories = [
    ".config/sunshine"
  ];
}
