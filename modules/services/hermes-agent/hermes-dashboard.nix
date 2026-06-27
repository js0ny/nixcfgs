{
  pkgs,
  lib,
  config,
  ...
}:
let
  insecure = true;
  bindAdress = "0.0.0.0";
  port = 9119;
  portStr = toString port;
  pkg = config.services.hermes-agent.package;

  insecureFlag = if insecure then "--insecure" else "";
in
{
  systemd.services.hermes-dashboard = {
    after = [ "hermes-agent.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      # --no-open: don't open the dashboard in the default browser on startup
      ExecStart = "${lib.getExe pkg} dashboard --host ${bindAdress} --port ${portStr} ${insecureFlag} --no-open";
      ExecStop = "${lib.getExe pkg} dashboard --stop";
      User = "hermes";
      Group = "hermes";
      Restart = "always";
      WorkingDirectory = "/var/lib/hermes";
      RestartSec = 5;
      AmbientCapabilities = "";
      CapabilityBoundingSet = "";
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
      ProcSubset = "pid";
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      # ProtectSystem = "strict";
      RemoveIPC = true;
      RestrictAddressFamilies = [
        "AF_UNIX"
        "AF_INET"
        "AF_INET6"
      ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      SystemCallErrorNumber = "EPERM";
      SystemCallFilter = [
        "@system-service"
        "~@clock @cpu-emulation @debug @module @mount @obsolete @privileged @raw-io @reboot @swap"
      ];
    };
  };
}
