{
  pkgs,
  config,
  secrets,
  myLib,
  ...
}:
let
  ep = config.nixdefs.endpoints;
  epSelf = ep.prometheus-alertmanager;
  sopsFile = secrets + "/alertmanager.yaml";
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
              {{ if eq .Status "firing" }}{{ if eq .CommonLabels.severity "critical" }}🚨{{ else }}⚠️{{ end }}{{ else }}✅{{ end }} <b>{{ .Status | toUpper }}</b> {{ .CommonLabels.alertname }}

              {{ range .Alerts }}
              🖥 <b>Instance:</b> {{ .Labels.instance }}
              📌 <b>Summary:</b> {{ .Annotations.summary }}
              📝 <b>Description:</b> {{ .Annotations.description }}
              {{ end }}

              📊 <a href="${ep.grafana.publicUrl}">Grafana</a>
            '';
          }
        ];
      }
    ];
  };
  fsSelector = builtins.concatStringsSep "," [
    ''fstype!~"tmpfs|devtmpfs|overlay|squashfs|fuse.*"''
    ''mountpoint!~"/boot/efi|/run.*|/var/lib/docker/.+|/var/lib/containers/.+"''
  ];
  alertRules = pkgs.writers.writeYAML "prometheus-alert-rules.yaml" {
    groups = [
      {
        name = "node_exporter";
        rules = [
          {
            alert = "FilesystemAlmostFull";
            # Bind mounts and Btrfs subvolumes share capacity; retain the lowest free-space ratio per device.
            expr = /* promql */ ''
              max without (mountpoint) (
                1 - (
                  node_filesystem_avail_bytes{${fsSelector}}
                    / node_filesystem_size_bytes{${fsSelector}}
                )
              ) > 0.90
            '';
            for = "10m";
            labels.severity = "warning";
            annotations = {
              summary = "Filesystem {{ $labels.device }} is {{ $value | humanizePercentage }} full";
              /*
                Rendered example:
                  belvedere:9100: /dev/nvme0n1p2 (btrfs) is 93.2% full.
                  📈 Used: 812.3GiB
                  📉 Free: 59.1GiB
                  💾 Total: 871.4GiB
                  📂 Mountpoints: /, /home, /nix
              */
              description = /* gotmpl */ ''
                {{ $labels.instance }}: {{ $labels.device }} ({{ $labels.fstype }}) is {{ $value | humanizePercentage }} full.
                📈 Used: {{ with printf "max(node_filesystem_size_bytes{instance=%q,device=%q}) - min(node_filesystem_avail_bytes{instance=%q,device=%q})" $labels.instance $labels.device $labels.instance $labels.device | query }}{{ . | first | value | humanize1024 }}B{{ end }}
                📉 Free: {{ with printf "min(node_filesystem_avail_bytes{instance=%q,device=%q})" $labels.instance $labels.device | query }}{{ . | first | value | humanize1024 }}B{{ end }}
                💾 Total: {{ with printf "max(node_filesystem_size_bytes{instance=%q,device=%q})" $labels.instance $labels.device | query }}{{ . | first | value | humanize1024 }}B{{ end }}
                📂 Mountpoints: {{ range $i, $m := printf `node_filesystem_size_bytes{instance=%q,device=%q,${fsSelector}}` $labels.instance $labels.device | query }}{{ if $i }}, {{ end }}{{ $m.Labels.mountpoint }}{{ end }}
              '';
            };
          }
          {
            alert = "PostgreSQLDown";
            expr = /* promql */ "pg_up == 0";
            for = "10m";
            labels.severity = "critical";
            annotations = {
              summary = "PostgreSQL is down";
              description = "{{ $labels.instance }} PostgreSQL exporter reports pg_up=0.";
            };
          }
          {
            alert = "HighCPUUsage";
            expr = /* promql */ ''
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
            expr = /* promql */ "node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes < 0.15";
            for = "30m";
            labels.severity = "warning";
            annotations = {
              summary = "Memory usage is over 85%";
              description = "{{ $labels.instance }} has less than 15% available memory.";
            };
          }
          {
            alert = "ExtremeHighMemoryUsage";
            expr = /* promql */ "node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes < 0.08";
            for = "5m";
            labels.severity = "warning";
            annotations = {
              summary = "Memory usage is over 92%";
              description = "{{ $labels.instance }} has less than 8% available memory.";
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
      sopsFile = secrets + "/telegram.yaml";
    };
  };

  sops.templates."alertmanager.env".content = myLib.attrsToEnvFile {
    TELEGRAM_BOT_TOKEN = config.sops.placeholder.alertmanager_telegram_bot_token;
    TELEGRAM_CHAT_ID = config.sops.placeholder.alertmanager_telegram_chat_id;
  };

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

}
