{
  pkgs,
  lib,
  config,
  ...
}: let
  username = config.nixdots.user.name;
  cfg = config.nixdots.desktop.dm;
in
  lib.mkIf (config.nixdots.desktop.enable && cfg == "tuigreet") {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          user = username;
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd 'uwsm start hyprland'";
        };
      };
    };
  }
