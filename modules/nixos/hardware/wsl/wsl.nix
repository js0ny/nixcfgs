{ lib, config, ... }:
lib.mkIf config.wsl.enable {
  wsl = {
    defaultUser = config.js0ny.user.name;
    wslConf.automount.mountFsTab = false;
  };
}
