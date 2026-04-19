_: {
  services.protonmail-bridge.enable = true;
  nixdots.persist.home = {
    directories = [
      ".local/share/protonmail"
    ];
  };
}
