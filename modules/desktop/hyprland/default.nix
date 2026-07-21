{
  flake.nixosModules.hyprland =
    {
      pkgs,
      inputs,
      config,
      ...
    }:
    let
      hyprland = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      xdg-desktop-portal-hyprland =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    in
    {
      programs.hyprland = {
        enable = true;
        withUWSM = true;
        xwayland.enable = true;
        systemd.setPath.enable = true;
        package = hyprland;
        portalPackage = xdg-desktop-portal-hyprland;
      };
      environment.systemPackages = with pkgs; [ grimblast ];
      programs.uwsm.enable = true;
      xdg.portal = {
        config.hyprland = {
          default = [
            "hyprland"
            "gtk"
          ];
          "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
          "org.freedesktop.impl.portal.OpenURI" = [ "gtk" ];
        };

        extraPortals = [ config.programs.hyprland.portalPackage ];
      };
      home-manager.sharedModules = [
        {
          wayland.windowManager.hyprland = {
            package = hyprland;
            portalPackage = xdg-desktop-portal-hyprland;
          };
        }
      ];
    };
  flake.homeModules.hyprland =
    {
      config,
      inputs,
      ...
    }:
    let
      mkSymlink = config.lib.file.mkOutOfStoreSymlink;
      dots = config.nixdots.core.dots;
    in
    {
      xdg.configFile =
        let
          files = [
            "animations.lua"
            "entry.lua"
            "keymaps.lua"
            "shell_keymaps.lua"
            "utils.lua"
            "vars.lua"
            "workspace-rules.lua"
            "windowrules"
          ];
        in
        builtins.listToAttrs (
          map (e: {
            name = "hypr/${e}";
            value.source = mkSymlink "${dots}/modules/desktop/hyprland/${e}";
          }) files
        )
        // {
          "hypr/.stylua.toml".source = "${inputs.self.outPath}/.stylua.toml";
        };

      wayland.windowManager.hyprland = {
        enable = true;
        configType = "lua";
        systemd.enableXdgAutostart = true;
        xwayland.enable = true;
        extraConfig = /* lua */ ''
          require("entry")
          hl.env("XCURSOR_SIZE", "${toString config.stylix.cursor.size}")
          hl.env("HYPRCURSOR_SIZE", "${toString config.stylix.cursor.size}")

          hl.on("hyprland.start", function()
            hl.exec_cmd("systemctl start --user waylandwm-session.target")
          end)
        '';
      };
    };
}
