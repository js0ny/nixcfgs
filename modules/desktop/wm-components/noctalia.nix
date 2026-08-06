{
  flake.homeModules.noctalia =
    {
      pkgs,
      lib,
      myLib,
      config,
      inputs,
      ...
    }:
    let
      d = config.nixdots;
      _locale = d.core.locales.guiLocale;
      locale = myLib.toHanScript _locale;
      wallpaperDir = config.home.customDirs.wallpaper;
      reloadConfig = pkgs.writeShellScriptBin "reload-compositor-config" ''
        if [[ $XDG_CURRENT_DESKTOP == "Hyprland" ]]; then
          hyprctl reload
        elif [[ $XDG_CURRENT_DESKTOP == "niri" ]]; then
          niri msg action load-config-file
        fi
      '';
    in
    {
      xdg.stateFile."noctalia/.setup-complete".text = "";
      imports = [
        inputs.self.homeModules.wm-components
        inputs.self.homeModules.kanshi
        inputs.noctalia.homeModules.default
      ];
      systemd.user.services.noctalia = {
        Unit = {
          PartOf = lib.mkForce [ "waylandwm-session.target" ];
          After = lib.mkForce [ "waylandwm-session.target" ];
        };
        Install.WantedBy = lib.mkForce [ "waylandwm-session.target" ];
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
              pinned = [ "Fcitx" ];
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
            started = lib.getExe reloadConfig;
          };
          plugins.enabled = [ "noctalia/world_clock" ];
        };
      };
      services.hyprpaper.enable = lib.mkForce false;
    };
}
