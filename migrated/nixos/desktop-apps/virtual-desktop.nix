{
  lib,
  config,
  ...
}:
lib.mkIf (config.hardware.graphics.enable) {
  boot = {
    kernelModules = [ "vkms" ];
    kernelParams = [
      "vkms.enable_cursor=1"
    ];
  };
}
