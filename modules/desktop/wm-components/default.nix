{
  flake.homeModules.wm-components =
    { pkgs, config, ... }:
    let
      wm = config.nixdots.desktop.wm;
    in
    {
      imports = [
        ./kanshi.nix
        ./polkit.nix
      ];
      home.packages = with pkgs; [
        brightnessctl
        localPkgs.power-profiles-next
        trash-cli
        grim
        slurp
        satty
      ];
      home.sessionVariables = {
        ELECTRON_TRASH = "trash-cli";
        XAUTHORITY = "$XDG_RUNTIME_DIR/.XAuthority";
      };
      services.cliphist.enable = (wm.clipboard == "cliphist");

      # Bind all wm-only services to waylandwm-session
      systemd.user.targets.waylandwm-session = {
        Unit = {
          Description = "Window Manager session, used to run services tied to the WM lifecycle";
          Documentation = [ "man:systemd.special(7)" ];
          PartOf = [ "graphical-session.target" ];
        };
      };
    };
}
