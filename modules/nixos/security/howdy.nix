{
  config,
  lib,
  ...
}: let
  hw = config.nixdots.laptop.cameraIR.devicePath;
  cfg = config.nixdots.pam.howdy;
in
  lib.mkIf cfg.enable {
    services.howdy = {
      enable = false;
      # control: "required" - the user must pass the howdy check to log in
      # control: "sufficient" - the user can log in if they pass the how
      control = "sufficient";
      settings = {
        core = {
          abort_if_lid_closed = true;
          abort_if_ssh = true;
          detection_notice = true;
          timeout_notice = true;
          no_confirmation = false;
        };
        video = {
          device_path = hw;
          dark_threshold = 80;
        };
      };
    };
    security.pam.services = {
      hyprlock.howdy.enable = true;
      polkit-1.howdy.enable = false;
    };
    programs.hyprlock.enable = true;
  }
