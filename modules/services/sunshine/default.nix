{
  flake.nixosModules.sunshine =
    {
      lib,
      config,
      ...
    }:
    let
      display = config.nixdots.linux.display;
      user = config.nixdots.user.name;
    in
    lib.mkIf (config.hardware.graphics.enable) {
      services.sunshine = {
        enable = true;
        autoStart = lib.mkDefault false;
        capSysAdmin = display == "wayland";
        openFirewall = true;
      };
      users.users.${user}.extraGroups = [ "uinput" ];
      services.avahi.enable = true;
      services.avahi.publish.enable = true;
      services.avahi.publish.userServices = true;
    };
}
