{
  flake.nixosModules.niri =
    { pkgs, ... }:
    let
      xwayland-satellite = pkgs.xwayland-satellite;
    in
    {
      programs.niri.enable = true;
      environment.systemPackages = [ pkgs.xwayland-satellite ];
      home-manager.sharedModules = [
        {
          wayland.windowManager.niri = {
            xwaylandSatellitePackage = xwayland-satellite;
          };
        }
      ];
    };
  flake.homeModules.niri = import ./module.nix;
}
