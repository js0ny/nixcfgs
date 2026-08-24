{
  flake.nixosModules.sunshine =
    {
      lib,
      config,
      ...
    }:
    let
      user = config.nixdots.user.name;
    in
    lib.mkIf (config.hardware.graphics.enable) {
      services.sunshine = {
        enable = true;
        autoStart = lib.mkDefault false;
        openFirewall = true;
      };
      users.users.${user}.extraGroups = [ "uinput" ];
      services.avahi.enable = true;
      services.avahi.publish.enable = true;
      services.avahi.publish.userServices = true;
    };
}
