{
  flake.nixosModules.desktop = { pkgs, lib, ... }: {
    systemd.user.services.coredump-notify = {
      wantedBy = [ "graphical-session.target" ];

      serviceConfig = {
        Restart = "always";
        RestartSec = 3;
      };

      # MESSAGE_ID: see `systemd-coredump(8)`: The relevant messages have MESSAGE_ID=fc2e22bc6ee647b6b90729ab34a250b1
      script =
        let
          jq = lib.getExe pkgs.jq;
        in
        # bash
        ''
          echo "[$(date)] coredump-notify started"

          ${lib.getExe' pkgs.systemd "journalctl"} -f -o json \
            MESSAGE_ID=fc2e22bc6ee647b6b90729ab34a250b1 |
          while read -r entry; do
            exe="$(${jq} -r '.COREDUMP_EXE // "unknown"' <<< "$entry")"
            sig="$(${jq} -r '.COREDUMP_SIGNAL_NAME // .COREDUMP_SIGNAL // "unknown"' <<< "$entry")"
            pid="$(${jq} -r '.COREDUMP_PID // "?"' <<< "$entry")"

            echo "[$(date)] coredump: exe=$exe sig=$sig pid=$pid"

            ${lib.getExe' pkgs.libnotify "coredump"} \
              " Coredump: $(basename "$exe")" \
              "$sig · PID $pid · $exe"
          done
        '';
    };
  };
}
