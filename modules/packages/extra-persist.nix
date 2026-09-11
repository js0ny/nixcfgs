{ config, ... }: {
  js0ny.persist.stores.local.directories = [
    ".local/share/agentsview"
    ".local/share/com.motrix.next"

    ".config/blender"
    ".config/bruno"
  ];

  home.sessionVariables = {
    AGENTSVIEW_DATA_DIR = "${config.xdg.dataHome}/agentsview";
  };

  mergetools = {
    "motrix-next-config" = {
      target = "${config.xdg.dataHome}/com.motrix.next/config.json";
      format = "json";
      settings = {
        autoCheckUpdate = false;
        locale = config.js0ny.host.locales.guiLocale;
      };
    };
  };

  xdg.configFile."krabby/config.toml".text = /* toml */ ''
    language = "en"
    shiny_rate = 0.0078125
  '';
}
