{
  pkgs,
  lib,
  config,
  ...
}:
let
  mic = config.nixdots.laptop.microphone;
in
{
  environment.systemPackages = with pkgs; [
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
  home-manager.sharedModules = [
    {
      services.easyeffects = {
        enable = true;
        extraPresets = {
          EasyMic = lib.importJSON ./EasyMic.json;
        };
      };
      systemd.user.services.easyeffects = {
        Unit = {
          PartOf = lib.mkForce [ "shell-init.target" ];
          After = lib.mkForce [ "shell-init.target" ];
        };
        Install.WantedBy = lib.mkForce [ "shell-init.target" ];
      };

      nixdots.persist.home.directories = [
        ".local/share/easyeffects"
      ];

    }
  ];
}
