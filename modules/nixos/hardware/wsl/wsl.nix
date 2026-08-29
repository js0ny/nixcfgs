{ lib, config, ... }:
lib.mkIf config.nixdots.linux.wsl {
  wsl = {
    enable = true;
    defaultUser = config.js0ny.user.name;
    wslConf.automount.mountFsTab = false;
  };
}
