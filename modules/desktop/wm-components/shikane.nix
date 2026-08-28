# shikane: dynamic Wayland output configuration manager
# switch profiles via: shikanectl switch <profile-name>
# export the current layout via: shikanectl export <profile-name>
{
  flake.homeModules.shikane =
    { config, lib, ... }:
    let
      internal = {
        search = "n=${config.nixdots.laptop.display.connector}";
        mode = "2880x1800@120";
        scale = 1.5;
      };
      lg4k60 = {
        search = "m=LG HDR 4K";
        mode = "3840x2160@59.997";
        scale = 1.875;
      };
      external = {
        search = "n/^(DP|HDMI).*$";
        mode = "preferred";
      };
      setEnabled = enable: output: output // { inherit enable; };
    in
    {
      services.shikane = {
        enable = false;
        # https://w0lff.gitlab.io/shikane/shikane.5.html
        settings = {
          profile = [
            {
              name = "laptop";
              output = [ (setEnabled true internal) ];
            }
            {
              name = "docked";
              output = [
                (setEnabled false internal)
                (setEnabled true lg4k60)
              ];
            }
            {
              name = "dual";
              output = [
                (setEnabled true (lg4k60 // { position = "0,0"; }))
                (setEnabled true (internal // { position = "3840,0"; }))
              ];
            }
            {
              name = "docked-generic";
              output = [
                (setEnabled false internal)
                (setEnabled true external)
              ];
            }
            {
              name = "dual-generic";
              output = [
                (setEnabled true (internal // { position = "0,0"; }))
                (setEnabled true (external // { position = "1920,0"; }))
              ];
            }
          ];
        };
      };

      systemd.user.services.shikane = {
        Unit = {
          PartOf = lib.mkForce [ "waylandwm-session.target" ];
          After = lib.mkForce [ "waylandwm-session.target" ];
        };
        Install.WantedBy = lib.mkForce [ "waylandwm-session.target" ];
      };
    };
}
