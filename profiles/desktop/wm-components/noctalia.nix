{
  flake.homeModules.noctalia =
    {
      pkgs,
      lib,
      myLib,
      config,
      inputs,
      secrets,
      ...
    }:
    let
      d = config.nixdots;
      _locale = d.core.locales.guiLocale;
      locale = myLib.toHanScript _locale;
      wallpaperDir = config.home.customDirs.wallpaper;
      noctaliaStartedHook = pkgs.writeShellScriptBin "noctalia-stared-hook" ''
        # Relaod Compositor Config
        if [[ $XDG_CURRENT_DESKTOP == "Hyprland" ]]; then
          hyprctl reload
        elif [[ $XDG_CURRENT_DESKTOP == "niri" ]]; then
          niri msg action load-config-file
        fi
        systemctl start --user shell-init.target
      '';
      noctaliaLoggintOutHook = pkgs.writeShellScriptBin "noctalia-logging-out-hook" ''
        systemctl stop --user shell-init.target
      '';
      noctaliaBatteryDischargingHook = pkgs.writeShellScriptBin "noctalia-battery-discharging-hook" ''
        tuned-adm profile powersave-override
      '';
    in
    {
      home.packages = [ pkgs.mpvpaper ];
      xdg.stateFile."noctalia/.setup-complete".text = "";
      imports = [
        inputs.self.homeModules.wm-components
        inputs.self.homeModules.shikane
        inputs.noctalia.homeModules.default
      ];
      systemd.user.services.noctalia = {
        Unit = {
          PartOf = lib.mkForce [ "wm-init.target" ];
          After = lib.mkForce [ "wm-init.target" ];
        };
        Install.WantedBy = lib.mkForce [ "wm-init.target" ];
      };
      programs.noctalia = {
        enable = true;
        systemd.enable = true;
        settings = {
          backdrop.enabled = false;
          brightness.enable_ddcutil = true;
          shell = {
            lang = locale;
            settings_show_advanced = true;
            avatar_path = "${config.xdg.configHome}/face.png";
            clipboard_enabled = false;
            time_format = "{:%H:%M:%S}";
            screenshot.directory = config.home.customDirs.screenshots;
            screen_time_enabled = true;
          };
          theme = {
            templates = {
              builtin_ids = [
                "hyprland"
                "niri"
                "labwc"
                "mango"
                "scroll"
                "sway"
              ];
            };
          };
          bar.default = {
            start = [
              "osicon"
              "taskbar"
              "media"
              "cpu"
              "ram"
            ];
            end = [
              "tray"
              "notifications"
              "network_tx"
              "network_rx"
              "network"
              "bluetooth"
              "volume"
              "brightness"
              "battery"
              "privacy"
            ];
            margin_edge = 0;
            margin_ends = 0;
            radius_top_left = 0;
            radius_top_right = 0;
            shadow = false;
          };
          dock = {
            enabled = true;
            auto_hide = true;
            reserve_space = false;
            show_dots = true;
          };
          location = {
            latitude = d.geo.latitude;
            longitude = d.geo.longitude;
            address = d.geo.city;
          };
          calendar.enabled = true;
          wallpaper = {
            transition = [
              "disc"
              "fade"
              "honeycomb"
              "stripes"
              "wipe"
              "zoom"
            ];
            transition_on_startup = true;
            directory = "${wallpaperDir}/";
            # stylix
            # default.path = "${wallpaperDir}/default.jpg";
          };
          widget = {
            privacy = {
              hide_inactive = true;
              active_color = "secondary";
              capsule = true;
              capsule_border = "secondary";
            };
            taskbar.group_by_workspace = true;
            tray = {
              drawer = true;
              pinned = [
                # Input Method
                "Fcitx"
                # Proxy
                "tray-icon tray app clash-verge-rev-tray"
                "Throne"
              ];
            };
            clock.format = "{:%H:%M:%S}";
            osicon = {
              capsule = true;
              color = "primary";
              glyph = "";
              label = " ";
              type = "custom_button";
              actions = {
                left = "exec vicinae toggle";
              };
            };
          };
          hooks = {
            started = lib.getExe noctaliaStartedHook;
            logging_out = lib.getExe noctaliaLoggintOutHook;
            battery_discharging = lib.getExe noctaliaBatteryDischargingHook;
          };
          plugins.enabled = [
            "noctalia/world_clock"
            "mdj2812/mihomo-control"
            "noctalia/mpvpaper"
          ];
          plugin_settings = {
            "mdj2812/mihomo-control" = {
              port = "9090";
            };
          };
          control_center.calendar.show_week_numbers = true;
        };
      };
      sops.secrets."noctalia_calendar.toml" = {
        sopsFile = secrets + "/files/noctalia_calendar.yaml";
        path = "${config.xdg.configHome}/noctalia/calendar.toml";
        key = "data";
      };
      services.hyprpaper.enable = lib.mkForce false;
    };
}
