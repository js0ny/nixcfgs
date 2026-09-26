{ lib, pkgs, ... }:
let
  F = lib.getExe' pkgs.coreutils "false";
in
{
  boot.extraModprobeConfig = lib.concatStringsSep "\n" [
    # https://copy.fail
    "blacklist algif_aead"
    "install algif_aead ${F}"
    # https://github.com/V4bel/dirtyfrag
    "install esp4 ${F}"
    "install esp6 ${F}"
    "install rxrpc ${F}"
  ];

  # https://github.com/V4bel/dirtyfrag
  # IPSec and AFS
  boot.blacklistedKernelModules = [
    "esp4"
    "esp6"
    "rxrpc"
  ];
}
