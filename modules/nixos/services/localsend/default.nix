{
  flake.nixosModules.localsend =
    { config, lib, ... }:
    {
      programs.localsend = {
        enable = true;
        openFirewall = false;
      };

      networking.firewall.interfaces = lib.genAttrs config.js0ny.hardware.localInterfaces (_: {
        allowedTCPPorts = [ 53317 ];
        allowedUDPPorts = [ 53317 ];
      });

      home-manager.sharedModules = [
        {
          xdg.dataFile."kio/servicemenus/localsend.desktop" = {
            source = ./localsend-kio.desktop;
            executable = true;
          };
        }
      ];
    };
}
