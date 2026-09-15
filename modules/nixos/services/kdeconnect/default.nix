{
  flake.nixosModules.kdeconnect =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      portRange = {
        from = 1714;
        to = 1764;
      };
      package = pkgs.kdePackages.kdeconnect-kde;
    in
    {
      # The upstream NixOS module opens these ports on every interface.
      environment.systemPackages = [ package ];

      networking.firewall.interfaces = lib.genAttrs config.js0ny.hardware.localInterfaces (_: {
        allowedTCPPortRanges = [ portRange ];
        allowedUDPPortRanges = [ portRange ];
      });

      home-manager.sharedModules = [
        {
          xdg.autostart.entries = [
            "${package}/share/applications/org.kde.kdeconnect.nonplasma.desktop"
          ];
        }
      ];
    };
}
