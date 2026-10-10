{
  pkgs,
  lib,
  config,
  secrets,
  myLib,
  ...
}:
let
  vaultDir = "/var/lib/hermes/workspace";
  inherit (config.services.hermes-agent) user group;
  fastNoteSyncConfig = {
    api = "\${FAST_NOTE_URL}";
    api_token = "\${FAST_NOTE_TOKEN}";
    vault = "LMWiki";
    vault_path = vaultDir;
    client_type = "GoFastNoteSync";
    sync_enabled = true;
    config_sync_enabled = true;
    offline_delete_sync_enabled = false;
    readonly_sync_enabled = false;
    manual_sync_enabled = false;
    offline_sync_strategy = "auto";
    sync_update_delay = 500;
    binary_sync_limit_enabled = true;
    concurrency_control_enabled = true;
    max_concurrent_uploads = 3;
    sync_exclude_folders = [ ];
    sync_exclude_extensions = [ ];
    sync_exclude_whitelist = [ ];
    config_sync_other_dirs = [ ];
    startup_delay = 0;
    auto_redirect_enabled = true;
    state_file = "";
    sync_timeout_seconds = 0;
  };
in
{
  sops.templates."go-fast-note-sync-agent-workspace.env".content = myLib.attrsToEnvFile {
    FAST_NOTE_TOKEN = config.sops.placeholder.hermes_fast_note_sync;
  };
  systemd.services.go-fast-note-sync-agent-workspace = {
    description = "Sync Workspace for Hermes Agent";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      FAST_NOTE_URL = config.nixdefs.endpoints.fast-note-sync.publicUrl;
    };
    serviceConfig = {
      ExecStart = lib.escapeShellArgs [
        (lib.getExe pkgs.js0ny.go-fast-note-sync)
        "start"
        "--config"
        (pkgs.writers.writeYAML "go-fast-note-sync.yaml" fastNoteSyncConfig)
      ];
      User = user;
      Group = group;
      Restart = "always";
      RestartSec = 5;
      EnvironmentFile = "${config.sops.templates."go-fast-note-sync-agent-workspace.env".path}";
    };
  };
  systemd.services.hermes-agent = {
    after = [ "go-fast-note-sync-agent-workspace.service" ];
    serviceConfig.ReadWritePaths = [ vaultDir ];
  };
  systemd.tmpfiles.rules = [
    "d ${vaultDir} 2775 ${user} ${group} - -"
    "Z ${vaultDir} 2775 ${user} ${group} - -"
    "A+ ${vaultDir} - - - - g:${group}:rwX,d:g:${group}:rwX"
  ];

  services.hermes-agent.environment = {
    OBSIDIAN_VAULT_PATH = vaultDir;
  };
  sops.secrets.hermes_fast_note_sync = {
    sopsFile = secrets + "/hermes.yaml";
  };
}
