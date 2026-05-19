{ config, lib, ... }:
let
  ep = config.nixdefs.endpoints;
  url = ep.bentopdf.domain;
in
{
  services.bentopdf = {
    enable = true;
    domain = url;
    nginx = {
      enable = true;
      virtualHost = {
        forceSSL = lib.mkDefault true;
        enableACME = lib.mkDefault true;
        extraConfig = /* nginx */ ''
          add_header Alt-Svc 'h3=":443"; ma=86400';
        '';
      };
    };
  };
}
