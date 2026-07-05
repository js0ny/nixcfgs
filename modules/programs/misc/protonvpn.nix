{
  pkgs,
  lib,
  config,
  ...
}:
let
  account = config.secrets.plain.protonAccount;
in
{
  targets.darwin.defaults."ch.protonvpn.mac" = lib.mkIf pkgs.stdenv.isDarwin {
    AutoConnect = 0;

    # DONT Check Update and DONT Auto Update
    SUAutomaticallyUpdate = 0;
    SUEnableAutomaticChecks = 0;
    RememberLoginAfterUpdate = 1;
    EarlyAccess = 0;

    StartMinimized = 1;
    SystemNotifications = 1;
    Welcomed = 1;

    # Telemetry
    "telemetry.settings.key" = 0;

    # Quick Connect
    # * st_f: Fastest
    # * st_r: Random
    "QuickConnect_${account}" = "st_f";

    # Protocol
    # * 0: WireGuard
    # * 1: Smart
    "smartProtocol" = 0;

    # Disable Telemetry
    "TelemetryUsageData${account}" = false;
    "TelemetryCrashReports${account}" = false;
  };
  home.packages = lib.optionals (config.nixdots.linux.enable) [
    pkgs.proton-vpn-cli
    pkgs.proton-vpn
  ];
  nixdots.darwin.homebrew.casks = [ "protonvpn" ];
}
