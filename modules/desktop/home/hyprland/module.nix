{
  pkgs,
  lib,
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
    ../wm-components/module.nix
  ];
  # {"diagnostics":{"globals":["hl"]},"workspace":{"library":["/nix/store/rv2dda5jgqr8vxd4ljp7vxmklmficxcm-hyprland-0.55.4/share/hypr/stubs"]}}
  xdg.configFile."hypr/hyprland_debug.lua".source =
    mkSymlink "${dots}/modules/desktop/home/hyprland/hyprland.lua";
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
