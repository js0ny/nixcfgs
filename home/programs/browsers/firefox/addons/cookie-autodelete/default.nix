{config, ...}: let
  p = config.nixdots.programs.firefox.defaultProfile;
in {
  programs.firefox.profiles."${p}".cookie-autodelete = {
    enable = true;
    active = true;
    cleanLocalStorage = true;
    enableContainers = true;
    showNotifications = false;
    allowList = [
      "*.github.com"
    ];
  };
}
