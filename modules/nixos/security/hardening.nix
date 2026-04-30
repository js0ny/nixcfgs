{ lib, pkgs, ... }:
{
  # https://copy.fail
  boot.extraModprobeConfig = ''
    blacklist algif_aead
    install algif_aead ${lib.getExe' pkgs.coreutils "false"}
  '';
}
