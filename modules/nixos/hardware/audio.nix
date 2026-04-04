{
  config,
  lib,
  ...
}: let
  mic = config.nixdots.laptop.microphone;
  cfg = config.nixdots.desktop.enable;
in
  lib.mkIf cfg {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };
    environment.etc."wireplumber/wireplumber.conf.d/51-rename-laptop-microphone.conf".text = ''

      monitor.alsa.rules = [
          {
              matches = [
                  {
                      node.name = "${mic.name}";
                  }
              ]
              actions = {
                  update-props = {
                      node.description = "${mic.description}";
                  }
              }
          }
      ]
    '';
  }
