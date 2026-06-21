{ config, ... }: {
  nixdots.persist.nosnap.home = {
    directories = [
      # keep-sorted start
      ".local/share/agentsview"
      ".local/share/com.motrix.next"
      # keep-sorted end
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
}
