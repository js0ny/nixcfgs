{
  flake.homeModules.easyeffects =
    { lib, config, ... }:
    lib.mkIf config.js0ny.hardware.microphone.enable {
      services.easyeffects = {
        enable = config.js0ny.hardware.laptop.enable;
        extraPresets = {
          EasyMic = lib.importJSON ./EasyMic.json;
        };
      };
      systemd.user.services.easyeffects = {
        Unit = {
          PartOf = lib.mkForce [ "waylandwm-session.target" ];
          After = lib.mkForce [ "waylandwm-session.target" ];
        };
        Install.WantedBy = lib.mkForce [ "waylandwm-session.target" ];
      };

      nixdots.persist.home = {
        directories = [
          ".local/share/easyeffects"
        ];
      };
    };
}
