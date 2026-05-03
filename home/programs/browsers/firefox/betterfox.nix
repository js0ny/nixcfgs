{ config, ... }:
let
  p = config.nixdots.programs.firefox.defaultProfile;
in
{
  programs.firefox.betterfox = {
    enable = true;
    profiles."${p}".settings = {
      securefox.enable = true;
      peskyfox.enable = true;
    };
  };
}
