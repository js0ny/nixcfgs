{
  flake.nixosModules.tether =
    {
      lib,
      pkgs,
      ...
    }:
    let
      package = pkgs.tether;
    in
    {
      environment.systemPackages = [ package ];

      # [Human Intervention] Install the extensions from the store, they are not
      # packaged in Nix. The Chromium one ships no store listing, side-load it.
      # https://addons.mozilla.org/en-US/firefox/addon/tether-browser-extension/
      # https://addons.thunderbird.net/en-US/thunderbird/addon/tether-mail-extension/
      programs.firefox.nativeMessagingHosts.packages = [ package ];
      environment.etc = {
        "chromium/native-messaging-hosts/com.tether.extension.json".source =
          "${package}/etc/chromium/native-messaging-hosts/com.tether.extension.json";
        "opt/chrome/native-messaging-hosts/com.tether.extension.json".source =
          "${package}/etc/opt/chrome/native-messaging-hosts/com.tether.extension.json";
      };

      # Thunderbird's wrapper defaults to linking native messaging hosts into
      # ~/.mozilla at runtime, which the sandbox cannot write to.
      programs.thunderbird.package = lib.mkForce (
        pkgs.nixpaks.thunderbird.override {
          package = pkgs.thunderbird.override {
            nativeMessagingHosts = [ package ];
            hasMozSystemDirPatch = true;
          };
        }
      );

      services.avahi = {
        enable = true;
        openFirewall = true;
        publish = {
          enable = true;
          userServices = true;
        };
      };
      networking.firewall.allowedTCPPorts = [ 5134 ];

      hardware.bluetooth = {
        enable = true;
        settings.General.Experimental = true;
      };
      systemd.services."tether-btclass@hci0" = {
        description = "Set Bluetooth Class of Device for Tether on hci0";
        after = [ "bluetooth.service" ];
        partOf = [ "bluetooth.service" ];
        wantedBy = [ "bluetooth.service" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          # btmgmt epolls stdin before running; hci0 can change after a controller
          # re-enumerates, so resolve the adapter on every attempt.
          ExecStart = pkgs.writeShellScript "tether-btclass-hci0" /* bash */ ''
            for attempt in $(${lib.getExe' pkgs.coreutils "seq"} 30); do
              hci=hci0
              [ -e /sys/class/bluetooth/$hci ] \
                || hci=$(${lib.getExe' pkgs.coreutils "ls"} /sys/class/bluetooth 2>/dev/null | ${lib.getExe' pkgs.coreutils "head"} -n1)
              if [ -n "$hci" ]; then
                echo | ${lib.getExe' pkgs.bluez "btmgmt"} --index "$hci" class 4 8 >/dev/null 2>&1
                if echo | ${lib.getExe' pkgs.bluez "btmgmt"} --index "$hci" info 2>/dev/null \
                  | ${lib.getExe pkgs.gnugrep} -q "class 0x..0408"; then
                  exit 0
                fi
              fi
              ${lib.getExe' pkgs.coreutils "sleep"} 1
            done
            exit 1
          '';
          TimeoutStartSec = 60;
        };
      };

      home-manager.sharedModules = [
        {
          # Pairing keys, contacts and journal live in the user's home, which is
          # ephemeral on hosts using preservation.
          js0ny.persist.stores.state.directories = [
            ".config/tether"
            ".local/share/tether"
            ".local/state/tether"
          ];
        }
      ];
    };
}
