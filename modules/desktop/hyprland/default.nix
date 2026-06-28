{
  flake.nixosModules.hyprland = _: {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
      systemd.setPath.enable = true;
    };
    programs.uwsm.enable = true;
  };
  flake.homeModules.hyprland = {
    imports = [ ./module.nix ];
  };
}
