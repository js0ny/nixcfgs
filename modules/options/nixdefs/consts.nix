{ lib, pkgs, ... }:
{
  options.nixdefs.consts = lib.mkOption { type = lib.types.attrs; };
  config.nixdefs.consts = {
    firefox.profileDir =
      if pkgs.stdenv.isDarwin then "Library/Application Support/Firefox/Profiles" else ".mozilla/firefox";
  };
}
