{
  pkgs,
  config,
  lib,
  ...
}:
let
  mic = config.nixdots.laptop.microphone;
in
{
  environment.systemPackages = with pkgs; [
    pulseaudio
    pwvucontrol
    playerctl
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
  services.playerctld.enable = true;
}
