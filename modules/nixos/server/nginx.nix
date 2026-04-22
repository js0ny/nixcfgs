{ pkgs, config, ... }:
let
  ports = config.nixdefs.ports;
in
{
  imports = [
    ./acme.nix
  ];

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    sslProtocols = "TLSv1.2 TLSv1.3";

    additionalModules = with pkgs.nginxModules; [ brotli ];
    appendHttpConfig = ''
      brotli on;
      brotli_comp_level 6;
      brotli_types application/atom+xml application/javascript application/json application/rss+xml application/vnd.ms-fontobject application/x-font-opentype application/x-font-truetype application/x-font-ttf application/x-javascript application/xhtml+xml application/xml font/eot font/opentype font/otf font/truetype image/svg+xml image/vnd.microsoft.icon image/x-icon image/x-win-bitmap text/css text/javascript text/plain text/xml;
    '';

    # Fallback
    virtualHosts."_" = {
      default = true;
      rejectSSL = true;

      locations."/" = {
        return = "444";
      };
    };

  };
  networking.firewall.allowedTCPPorts = [
    ports.HTTP
    ports.HTTPS
  ];
  # HTTP/3 is built on UDP
  networking.firewall.allowedUDPPorts = [ ports.HTTPS ];
}
