{
  pkgs,
  config,
  lib,
  secrets,
  ...
}:
let
  # Hungarian Notation
  ## c: Category
  ## l: Link
  ## f: Feed
  cRelease = "Software Releases";
  cGaming = "Gaming";

  lGitHub = repo: "https://github.com/${repo}/releases.atom";
  lRssHub = endpoint: "http://${config.nixdefs.endpoints.rsshub.listenStr}/${endpoint}";

  fGitHubRelease = repo: {
    feed_url = lGitHub repo;
    category = cRelease;
    blocklist_rules = "EntryTitle=(?i)(prerelease|alpha|nightly)";
  };

  fsGitHub = map fGitHubRelease [
    # Editor
    "neovim/neovim"
    "neovide/neovide"
    # Terminal Emulator
    "ghostty-org/ghostty"
    "kovidgoyal/kitty"
    "l0ng-ai/tty7"
    "zellij-org/zellij"
    # Shell
    "fish-shell/fish-shell"
    "nushell/nushell"
    # Desktop Linux
    "niri-wm/niri"
    "hyprwm/Hyprland"
    "noctalia-dev/noctalia"
    "vicinaehq/vicinae"
    "zackb/tether"
    # Nix
    "NixOS/nix"
    "nix-community/nh"
    # Networking
    "SagerNet/sing-box"
    # LLM Agent
    "earendil-works/pi"
    "can1357/oh-my-pi"
    "NousResearch/hermes-agent"
    "deepseek-ai/deepseek-harness"
    # Browser
    "servo/servo"
    # Misc
    "longbridge/gpui-kit"
    "AvaloniaUI/avalonia"
    "zealsprince/rox"
    "sonorahq/sonora"
    "ahrm/sioyek"
    # Selfhosted
    "we-promise/sure"
  ];

  miniflux-sync = pkgs.callPackage ./miniflux-sync/package.nix { };
  configAttrsBase = {
    categories = [
      cRelease
      cGaming
    ];
    feeds = fsGitHub ++ [
      {
        feed_url = "https://techhub.social/@hmnews.rss";
        category = cRelease;
      }
    ];
  };
  # configAttrsSecrets = import (secrets + "/nixos/indep/miniflux.nix");
  configFile = pkgs.writeText "miniflux-sync.json" (
    builtins.toJSON (
      configAttrsBase # // configAttrsSecrets
    )
  );
in
{
  sops.secrets.miniflux_user_sync_token = {
    sopsFile = secrets + "/miniflux.yaml";
  };

  systemd.services.miniflux-sync = {
    description = "Synchronise declarative Miniflux subscriptions";
    wantedBy = [ "multi-user.target" ];
    requires = [ "miniflux.service" ];
    wants = [ "network-online.target" ];
    after = [
      "miniflux.service"
      "nginx.service"
      "network-online.target"
    ];
    restartTriggers = [ configFile ];
    environment = {
      MINIFLUX_URL = config.nixdefs.endpoints.miniflux.publicUrl;
      MINIFLUX_CONFIG_FILE = toString configFile;
      MINIFLUX_API_TOKEN_FILE = "%d/api-token";
    };
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      DynamicUser = true;
      ExecStart = lib.getExe miniflux-sync;
      LoadCredential = [
        "api-token:${config.sops.secrets.miniflux_user_sync_token.path}"
      ];
    };
  };
}
