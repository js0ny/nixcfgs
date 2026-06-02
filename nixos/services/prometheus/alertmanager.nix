{
  pkgs,
  config,
  secrets,
  ...
}:
let
  ep = config.nixdefs.endpoints;
  epSelf = ep.prometheus-alertmanager;
  sopsFile = secrets + /alertmanager.yaml;
  alertmanagerConfig = pkgs.writers.writeYAML "alertmanager.yaml" {
    route = {
      receiver = "telegram";
      group_by = [
        "alertname"
        "instance"
      ];
      group_wait = "30s";
      group_interval = "5m";
      repeat_interval = "4h";
    };

    receivers = [
      {
        name = "telegram";
        telegram_configs = [
          {
            bot_token = "$TELEGRAM_BOT_TOKEN";
            chat_id = "$TELEGRAM_CHAT_ID";
            send_resolved = true;
            parse_mode = "HTML";
            message = /* gotmpl */ ''
              <b>{{ .Status | toUpper }}</b> {{ .CommonLabels.alertname }}

              {{ range .Alerts }}
              <b>Instance:</b> {{ .Labels.instance }}
              <b>Summary:</b> {{ .Annotations.summary }}
              <b>Description:</b> {{ .Annotations.description }}
              {{ end }}
            '';
          }
        ];
      }
    ];
  };
  alertRules = pkgs.writers.writeYAML "prometheus-alert-rules.yaml" {
    groups = [
      {
        name = "node_exporter";
        rules = [
          {
            alert = "FilesystemAlmostFull";
            expr = ''
              node_filesystem_avail_bytes{fstype!~"tmpfs|devtmpfs|overlay|squashfs|fuse.*",mountpoint!~"/boot/efi|/run.*|/var/lib/docker/.+|/var/lib/containers/.+"}
                / node_filesystem_size_bytes{fstype!~"tmpfs|devtmpfs|overlay|squashfs|fuse.*",mountpoint!~"/boot/efi|/run.*|/var/lib/docker/.+|/var/lib/containers/.+"}
                < 0.10
            '';
            for = "10m";
            labels.severity = "warning";
            annotations = {
              summary = "Filesystem is over 90% full";
              description = "{{ $labels.instance }} {{ $labels.mountpoint }} has less than 10% free space.";
            };
          }
          {
            alert = "PostgreSQLDown";
            expr = "pg_up == 0";
            for = "10m";
            labels.severity = "critical";
            annotations = {
              summary = "PostgreSQL is down";
              description = "{{ $labels.instance }} PostgreSQL exporter reports pg_up=0.";
            };
          }
          {
            alert = "HighCPUUsage";
            expr = ''
              1 - avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) > 0.95
            '';
            for = "30m";
            labels.severity = "warning";
            annotations = {
              summary = "CPU usage is over 95%";
              description = "{{ $labels.instance }} CPU usage has been over 95% for 30m.";
            };
          }
          {
            alert = "HighMemoryUsage";
            expr = "node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes < 0.10";
            for = "30m";
            labels.severity = "warning";
            annotations = {
              summary = "Memory usage is over 90%";
              description = "{{ $labels.instance }} has less than 10% available memory.";
            };
          }
        ];
      }
    ];
  };
in
{
  sops.secrets = {
    alertmanager_telegram_bot_token = { inherit sopsFile; };
    alertmanager_telegram_chat_id = {
      key = "tg_main_chatid";
      sopsFile = secrets + /telegram.yaml;
    };
  };

  sops.templates."alertmanager.env".content = /* bash */ ''
    TELEGRAM_BOT_TOKEN=${config.sops.placeholder.alertmanager_telegram_bot_token}
    TELEGRAM_CHAT_ID=${config.sops.placeholder.alertmanager_telegram_chat_id}
  '';

  services.prometheus.alertmanager = {
    enable = true;
    port = epSelf.port;
    listenAddress = epSelf.bindAddress;
    environmentFile = config.sops.templates."alertmanager.env".path;
    checkConfig = false;
    configText = builtins.readFile alertmanagerConfig;
  };

  services.prometheus.ruleFiles = [ alertRules ];

  services.prometheus.alertmanagers = [
    {
      static_configs = [
        { targets = [ "localhost:${epSelf.portStr}" ]; }
      ];
    }
  ];

  nixdots.persist.system.directories = [ "/var/lib/alertmanager" ];
}
