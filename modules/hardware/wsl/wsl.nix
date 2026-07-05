{ lib, config, ... }:
lib.mkIf config.nixdots.linux.wsl {
  wsl = {
    enable = true;
    defaultUser = config.nixdots.user.name;
    wslConf.automount.mountFsTab = false;
  };
}
