{
  flake.nixosModules.desktop = { pkgs, lib, ... }: {
    # Force disable drkonqi
    systemd.services."drkonqi-coredump-processor@" = {
      wantedBy = lib.mkForce [ ];
      enable = lib.mkForce false;
    };
    systemd.user.services.coredump-notify = {
      wantedBy = [ "graphical-session.target" ];

      serviceConfig = {
        Restart = "always";
        RestartSec = 3;
      };

      # MESSAGE_ID: see `systemd-coredump(8)`: The relevant messages have MESSAGE_ID=fc2e22bc6ee647b6b90729ab34a250b1
      script =
        let
          coredumpctl = lib.getExe' pkgs.systemd "coredumpctl";
          jq = lib.getExe pkgs.jq;
          notifySend = lib.getExe' pkgs.libnotify "notify-send";
          systemdRun = lib.getExe' pkgs.systemd "systemd-run";
          terminal = lib.getExe pkgs.xdg-terminal-exec;
        in
        # bash
        ''
          echo "[$(date)] coredump-notify started"

          ${lib.getExe' pkgs.systemd "journalctl"} \
            --follow \
            --lines=0 \
            --output=json \
            --output-fields=COREDUMP_EXE,COREDUMP_SIGNAL_NAME,COREDUMP_SIGNAL,COREDUMP_PID \
            MESSAGE_ID=fc2e22bc6ee647b6b90729ab34a250b1 |
          while IFS= read -r entry; do
            exe="$(${jq} -r '.COREDUMP_EXE // "unknown"' <<< "$entry")"
            sig="$(${jq} -r '.COREDUMP_SIGNAL_NAME // .COREDUMP_SIGNAL // "unknown"' <<< "$entry")"
            pid="$(${jq} -r '.COREDUMP_PID // "?"' <<< "$entry")"

            echo "[$(date)] coredump: exe=$exe sig=$sig pid=$pid"

            # Actions make notify-send wait for user input, so do not block journal consumption.
            (
              action="$(${notifySend} \
                --action="view=View" \
                --action="debug=Debug" \
                --action="dismiss=Dismiss" \
                " Coredump: $(basename "$exe")" \
                "$sig · PID $pid · $exe")"

              # Transient units inherit the user manager's desktop environment and full PATH.
              case "$action" in
                view)
                  ${systemdRun} --user --collect --service-type=exec -- \
                    ${terminal} --app-id="coredumpctl" --hold ${coredumpctl} info "$pid"
                  ;;
                debug)
                  ${systemdRun} --user --collect --service-type=exec -- \
                    ${terminal} --app-id="coredumpctl" --hold ${coredumpctl} debug "$pid"
                  ;;
                dismiss|"")
                  ;;
              esac
            ) &
          done
        '';
    };
  };
}
