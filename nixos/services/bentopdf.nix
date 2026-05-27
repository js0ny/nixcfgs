{ config, lib, ... }:
let
  ep = config.nixdefs.endpoints;
  url = ep.bentopdf.domain;
in
{
  services.bentopdf = {
    enable = true;
  }
  // lib.optionAttrs (url != null) {
    domain = url;
    nginx = {
      enable = true;
      virtualHost = {
        forceSSL = lib.mkDefault true;
        enableACME = lib.mkDefault true;
      };
    };
  };
}
