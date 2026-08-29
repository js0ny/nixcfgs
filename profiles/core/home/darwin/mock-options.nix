{ lib, ... }: {
  options.programs.steam = lib.mkOption {
    type = lib.types.anything;
  };

}
