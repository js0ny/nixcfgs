{ lib, ... }:
{
  options.nixdefs.ports = lib.mkOption {
    type = lib.types.attrs;
  };
  config.nixdefs.ports = {
    SSH = 22;
    HTTP = 80;
    HTTPS = 443;
  };
}
