{ inputs, ... }: {
  imports = [ inputs.gaze.nixosModules.default ];
  # https://gaze.gundulabs.com/guide/nixos.html
  services.gaze = {
    enable = true;
    gui.enable = true;
    mutableConfig = false;
    # https://gaze.gundulabs.com/guide/configuration.html
    settings = { };
  };
  nixdots.persist.system.directories = [
    "/var/lib/gaze"
    "/var/cache/gaze"
    "/etc/gaze"
  ];
}
