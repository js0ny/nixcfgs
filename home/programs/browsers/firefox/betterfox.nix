{ config, ... }:
let
  p = config.nixdots.programs.firefox.defaultProfile;
in
{
  programs.firefox.betterfox = {
    enable = true;
    profiles."${p}".settings = {
      fastfox.enable = true;
      securefox.enable = true;
      peskyfox.enable = true;
    };
  };
}
