{
  flake.nixosModules.jellyfin =
    {
      pkgs,
      lib,
      config,
      myLib,
      ...
    }:
    let
      ep = config.nixdefs.endpoints;
      url = ep.jellyfin.domain;
      socketPath = "/run/jellyfin/jellyfin.sock";
      branding = pkgs.replaceVars ./branding.xml {
        jellyfinUrl = ep.jellyfin.publicUrl;
      };
      user = config.services.jellyfin.user;
      group = config.services.jellyfin.group;
    in
    {
      imports = myLib.scanPaths ./.;
      services.jellyfin = {
        enable = true;
        openFirewall = false;
      };
      systemd.services.jellyfin = {
        environment = {
          JELLYFIN_kestrel__socket = "true";
          JELLYFIN_kestrel__socketPath = socketPath;
          JELLYFIN_kestrel__socketPermissions = "666";
        };
        serviceConfig.RuntimeDirectory = "jellyfin";
      };
      systemd.tmpfiles.rules = [
        "Z ${config.services.jellyfin.dataDir} 0775 ${user} ${group} - -"
        "L+ ${config.services.jellyfin.configDir}/branding.xml - - - - ${branding}"
      ];

      services.nginx.virtualHosts = lib.mkIf (url != null) {
        ${url} = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://unix:${socketPath}:/";
            proxyWebsockets = true;
            extraConfig = /* nginx */ ''
              proxy_buffering off;
              proxy_request_buffering off;
              proxy_read_timeout 3600;
              proxy_send_timeout 3600;
            '';
          };
        };
      };
      nixdots.persist.system.directories = [ config.services.jellyfin.dataDir ];
      fonts = {
        packages = [ pkgs.noto-fonts-cjk-sans ];
        fontDir.enable = true;
      };
    };
}
