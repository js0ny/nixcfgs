# shikane: dynamic Wayland output configuration manager
# switch profiles via: shikanectl switch <profile-name>
# export the current layout via: shikanectl export <profile-name>
{
  flake.homeModules.shikane =
    { config, lib, ... }:
    let
      #   internal = {
      #     search = "n=${config.nixdots.laptop.display.connector}";
      #     mode = "2880x1800@120";
      #     scale = 1.5;
      #   };
      #   lg4k60 = {
      #     search = "m=LG HDR 4K";
      #     mode = "3840x2160@59.997";
      #     scale = 1.875;
      #   };
      #   external = {
      #     search = "n/^(DP|HDMI).*$";
      #     mode = "preferred";
      #   };
      #   setEnabled = enable: output: output // { inherit enable; };
      cfg = config.services.shikane;
    in
    {
      services.shikane = {
        enable = true;
        # https://w0lff.gitlab.io/shikane/shikane.5.html
        settings = fromTOML /* toml */ ''
          [[profile]]
          name = "g7u-docked"

          [[profile.output]]
          enable = true
          search = ["m=G7u Pro", "s=0001", "v=SAC"]
          mode = "3840x2160@144.00Hz"
          position = "1440,0"
          scale = 1.5
          transform = "normal"
          adaptive_sync = false

          [[profile.output]]
          enable = false
          search = ["m=ATNA40CU05-0 ", "s=", "v=Samsung Display Corp."]
          mode = "2880x1800@120Hz"
          position = "0,0"
          scale = 1.5
          transform = "normal"
          adaptive_sync = false

          [[profile]]
          name = "laptop"

          [[profile.output]]
          enable = true
          search = ["m=ATNA40CU05-0 ", "s=", "v=Samsung Display Corp."]
          mode = "2880x1800@120Hz"
          position = "0,0"
          scale = 1.5
          transform = "normal"
          adaptive_sync = false
        '';
      };

      systemd.user.services.shikane = lib.mkIf cfg.enable {
        Unit = {
          PartOf = lib.mkForce [ "wm-init.target" ];
          After = lib.mkForce [ "wm-init.target" ];
        };
        Install.WantedBy = lib.mkForce [ "wm-init.target" ];
      };
    };
}
