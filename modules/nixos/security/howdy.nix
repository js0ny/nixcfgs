{
  config,
  lib,
  ...
}:
let
  hw = config.nixdots.laptop.cameraIR.devicePath;
  cfg = config.nixdots.pam.howdy;
  desktop = config.nixdots.desktop;
in
lib.mkIf cfg.enable {
  services.howdy = {
    enable = cfg.setup;
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
    polkit-1.howdy.enable = true; # KDE/Gnome Polkit is preferred
    login.howdy.enable = lib.mkDefault (if desktop.dm == "gdm" then true else false);
  };

  systemd.services."polkit-agent-helper@".serviceConfig = {
    PrivateDevices = false;
    DeviceAllow = "char-video4linux rw";
  };
}
