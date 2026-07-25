{
  flake.homeModules.easyeffects =
    { lib, ... }:
    {
      services.easyeffects = {
        enable = true;
        extraPresets = {
          EasyMic = lib.importJSON ./EasyMic.json;
        };
      };
      systemd.user.services.easyeffects = {
        Unit = {
          PartOf = [ "waylandwm-session.target" ];
          After = [ "waylandwm-session.target" ];
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
