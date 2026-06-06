{ ... }:
{
  services.vikunja = {
    enable = true;
    address = "0.0.0.0";
    frontendHostname = "tasks.js0ny.net";
    frontendScheme = "http";
    #  https://vikunja.io/docs/config-options/
    settings = {
      service = {
        enablelinksharing = false;
        enableregistration = false;
      };
      auth = {
        openid.enabled = true;
      };
    };
  };
}
