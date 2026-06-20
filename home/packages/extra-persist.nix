{ config, ... }: {
  nixdots.persist.nosnap.home = {
    directories = [
      # keep-sorted start
      ".local/share/com.motrix.next"
      # keep-sorted end
    ];
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
