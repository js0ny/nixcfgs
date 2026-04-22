{ lib, ... }:
{
  options.nixdefs.consts = lib.mkOption { type = lib.types.attrs; };
}
