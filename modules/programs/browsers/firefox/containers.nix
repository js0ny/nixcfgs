{ pkgs, config, ... }:
let
  fx = config.js0ny.user.name;
  fxb = config.nixdefs.consts.firefox.profileDir;
  containerise = pkgs.js0ny.containerise-managed;
in
{
  mergetools.firefox-containers = {
    target = "${config.home.homeDirectory}/${fxb}/${fx}/containers.json";
    format = "json";
    settings = {
      identities = [
        {
          userContextId = 6;
          public = true;
          icon = "fence";
          color = "yellow";
          name = "Google";
        }
        {
          userContextId = 7;
          public = true;
          icon = "fingerprint";
          color = "purple";
          name = "Bot";
        }
        {
          userContextId = 8;
          public = true;
          icon = "briefcase";
          color = "red";
          name = "Academia";
        }
        {
          userContextId = 9;
          public = true;
          icon = "fingerprint";
          color = "red";
          name = "Chinese";
        }
        {
          userContextId = 10;
          public = true;
          icon = "briefcase";
          color = "orange";
          name = "Anthropic";
        }
        {
          userContextId = 11;
          public = true;
          icon = "briefcase";
          color = "gray";
          name = "SpaceX";
        }
        {
          userContextId = 12;
          public = true;
          icon = "fence";
          color = "cyan";
          name = "Facebook";
        }
      ];
    };
  };

  programs.firefox.profiles.${fx}.extensions.packages = [ containerise ];
}
