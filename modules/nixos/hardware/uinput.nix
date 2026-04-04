{
  lib,
  config,
  ...
}: let
  username = config.nixdots.user.name;
  cfg = config.nixdots.desktop.xremap.enable;
in
  lib.mkIf cfg {
    hardware.uinput.enable = true;
    boot.kernelModules = ["uinput"];
    services.udev.extraRules = ''
      KERNEL=="uinput", GROUP="input", TAG+="uaccess"
    '';
    users.users."${username}".extraGroups = ["input" "uinput"];
  }
