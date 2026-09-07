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
      services.avahi = {
        enable = true;
        publish.enable = true;
        publish.userServices = true;
      };
      home-manager.sharedModules = [
        {
          js0ny.persist.stores.state.directories = [ ".config/sunshine" ];
        }
      ];
    };
}
