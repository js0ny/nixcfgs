{
  imports = [
    ./noctalia.nix
    ./dms.nix
    ./wm-polkit.nix
    ./kanshi.nix
  ];
  flake.homeModules.wm-components =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        brightnessctl
        trash-cli
        grim
        slurp
        satty
      ];
      home.sessionVariables = {
        ELECTRON_TRASH = "trash-cli";
        XAUTHORITY = "$XDG_RUNTIME_DIR/.XAuthority";
      };
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
