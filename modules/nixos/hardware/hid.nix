{config, ...}: let
  username = config.nixdots.user.name;
in {
  # 19f5: Nuphy Keyboards
  services.udev.extraRules = ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="19f5", SUBSYSTEM=="hidraw", GROUP="plugdev", MODE="0660"
  '';

  users.groups.plugdev = {};

  users.users."${username}" = {
    extraGroups = ["plugdev"];
  };
}
