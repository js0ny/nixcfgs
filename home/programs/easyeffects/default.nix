{ lib, ... }:
{
  services.easyeffects = {
    enable = true;
    extraPresets = {
      EasyMic = lib.importJSON ./EasyMic.json;
    };
  };

  nixdots.persist.home = {
    directories = [
      ".local/share/easyeffects"
    ];
  };
}
