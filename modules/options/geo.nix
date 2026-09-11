{ lib, ... }: {
  options.js0ny.geo = {
    longitude = lib.mkOption {
      type = lib.types.nullOr lib.types.number;
    };
    latitude = lib.mkOption {
      type = lib.types.nullOr lib.types.number;
    };
    city = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
    };
  };
}
