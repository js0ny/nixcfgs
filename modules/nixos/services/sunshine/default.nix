{
  flake.nixosModules.sunshine =
    {
      lib,
      config,
      ...
    }:
    lib.mkIf (config.hardware.graphics.enable) {
      services.sunshine = {
        enable = true;
        autoStart = lib.mkDefault false;
        openFirewall = true;
      };
      js0ny.user.groups = [ "uinput" ];
      services.avahi.enable = true;
      services.avahi.publish.enable = true;
      services.avahi.publish.userServices = true;
    };
}
