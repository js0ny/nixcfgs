{ config, ... }: {
  js0ny.persist.stores.local.directories = [
    ".local/share/agentsview"
    ".local/share/com.motrix.next"

    ".config/blender"
    ".config/bruno"

    ".config/sonora"
    ".local/share/sonora"
    ".cache/sonora"
  ];

  js0ny.persist.stores.local.files = [
    {
      file = ".config/gcx/config.yaml";
      how = "symlink";
    }
  ];

  home.sessionVariables = {
    AGENTSVIEW_DATA_DIR = "${config.xdg.dataHome}/agentsview";
  };

  xdg.configFile."krabby/config.toml".text = /* toml */ ''
    language = "en"
    shiny_rate = 0.0078125
  '';
}
