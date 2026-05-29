{ config, ... }:
let
  url = "flux.js0ny.net";
in
{
  systemd.tmpfiles.rules = [
    "d /var/www/flux 0755 root root -"
  ];

  services.nginx.virtualHosts."${url}" = {
    root = "/var/www/flux";

    locations."~* \\.(?:ico|css|js|gif|jpe?g|png|woff2?|eot|ttf|svg)$" = {
      extraConfig = /* nginx */ ''
        expires 30d;
        add_header Cache-Control "public, no-transform";
      '';
    };
  }
  // config.nixdefs.consts.nginxWithCF;
}
