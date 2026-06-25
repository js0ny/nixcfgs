{ config, ... }: {
  nixdots.persist.nosnap.home = {
    directories = [
      ".local/share/agentsview"
      ".local/share/com.motrix.next"

      ".config/blender"
      ".config/Proton Pass"

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

  xdg.desktopEntries = {
    ltspice = {
      comment = "SPICE simulator, schematic capture and waveform viewer";
      exec = "ltspice %f";
      icon = "ltspice";
      mimeType = [
        "application/raw"
        "application/asc"
        "application/res"
        "application/asy"
        "application/bead"
        "application/bjt"
        "application/cap"
        "application/dio"
        "application/ind"
        "application/jft"
        "application/mos"
      ];
      categories = [
        "Science"
        "Electronics"
        "Engineering"
      ];
      name = "LTspice";
    };
    MotrixNext = {
      name = "MotrixNext";
      exec = "motrix-next %U";
      icon = "motrix-next";
      genericName = "Download manager";
      comment = "A full-featured download manager";
      categories = [
        "Network"
        "FileTransfer"
      ];
      settings = {
        StartupWMClass = "motrix-next";
      };
    };
  };
}
