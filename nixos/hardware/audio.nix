{
  pkgs,
  config,
  lib,
  ...
}:
let
  mic = config.nixdots.laptop.microphone;
  cfg = config.nixdots.desktop.enable;
in
lib.mkIf cfg {
  environment.systemPackages =
    with pkgs;
    [
      pulseaudio
    ]
    ++ lib.optionals (config.hardware.graphics.enable) [
      pwvucontrol
    ];
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    wireplumber.extraConfig = {
      "rename-laptop-microphone" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                node.name = "${mic.name}";
              }
            ];
            actions = {
              update-props = {
                node.description = "${mic.description}";
              };
            };
          }
        ];
      };
    };
  };
}
