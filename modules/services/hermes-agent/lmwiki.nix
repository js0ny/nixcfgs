{
  pkgs,
  lib,
  config,
  secrets,
  ...
}:
let
  vaultDir = "/var/lib/lmwiki";
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
  sops.templates."go-fast-note-sync-lmwiki.env".content = /* bash */ ''
    FAST_NOTE_TOKEN=${config.sops.placeholder.hermes_fast_note_sync}
  '';
  systemd.services.go-fast-note-sync-lmwiki = {
    description = "Sync LMWiki for Hermes Agent";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      FAST_NOTE_URL = config.nixdefs.endpoints.fast-note-sync.publicUrl;
    };
    serviceConfig = {
      ExecStart = "${lib.getExe pkgs.js0ny.go-fast-note-sync} start --config ${pkgs.writers.writeYAML "go-fast-note-sync.yaml" fastNoteSyncConfig}";
      User = "hermes";
      Group = "hermes";
      Restart = "always";
      RestartSec = 5;
      EnvironmentFile = "${config.sops.templates."go-fast-note-sync-lmwiki.env".path}";
    };
  };
  systemd.services.hermes-agent = {
    after = [ "go-fast-note-sync-lmwiki.service" ];
    serviceConfig.ReadWritePaths = [ vaultDir ];
  };
  systemd.tmpfiles.rules = [
    "d ${vaultDir} 2775 hermes agents - -"
    "Z ${vaultDir} 2775 hermes agents - -"
    "A+ ${vaultDir} - - - - g:agents:rwX,d:g:agents:rwX"
  ];
  nixdots.persist.system.directories = [
    {
      directory = vaultDir;
      mode = "2775";
      user = "hermes";
      group = "agents";
    }
  ];

  services.hermes-agent.environment = {
    OBSIDIAN_VAULT_PATH = vaultDir;
    WIKI_PATH = vaultDir;
  };
  sops.secrets.hermes_fast_note_sync = {
    sopsFile = secrets + /hermes.yaml;
  };
}
