{
  pkgs,
  inputs,
  config,
  ...
}:
let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  dots = config.nixdots.core.dots;
in
{
  home.packages = with pkgs; [
    grimblast
  ];
  imports = [
    inputs.self.homeModules.noctalia
  ];
  xdg.configFile."hypr/hyprland_debug.lua".source =
    mkSymlink "${dots}/modules/desktop/hyprland/hyprland.lua";
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    systemd.enableXdgAutostart = true;
    xwayland.enable = true;
    extraConfig = /* lua */ ''
      require("hyprland_debug")
    '';
  };
}
