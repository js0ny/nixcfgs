{ config, ... }:
let
  p = config.nixdots.programs.firefox.defaultProfile;
in
{
  programs.firefox.profiles."${p}" = {
    userChrome = builtins.readFile ./userChrome.css;
  };
}
