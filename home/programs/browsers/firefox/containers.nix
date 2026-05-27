{ config, ... }:
let
  fx = config.nixdots.user.name;
  fxb = config.nixdefs.consts.firefox.profileDir;
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
      ];
    };
  };
}
