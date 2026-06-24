{ config, ... }: {
  nixdots.persist.nosnap.home = {
    directories = [
      ".local/share/agentsview"
      ".local/share/com.motrix.next"

      ".config/blender"

      ".config/FreeCAD"
      ".local/share/FreeCAD"

      ".config/kicad"
      ".local/share/kicad"
    ];
  };

  home.sessionVariables = {
    AGENTSVIEW_DATA_DIR = "${config.xdg.dataHome}/agentsview";
  };

  mergetools = {
    "motrix-next-config" = {
      target = "${config.xdg.dataHome}/com.motrix.next/config.json";
      format = "json";
      settings = {
        autoCheckUpdate = false;
        locale = config.nixdots.core.locales.guiLocale;
      };
    };
  };

  xdg.configFile."krabby/config.toml".text = /* toml */ ''
    language = "en"
    shiny_rate = 0.0078125
  '';
}
