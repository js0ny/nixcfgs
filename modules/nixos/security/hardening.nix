{ lib, pkgs, ... }:
{
  boot.extraModprobeConfig =
    # https://copy.fail
    ''
      blacklist algif_aead
      install algif_aead ${lib.getExe' pkgs.coreutils "false"}
    ''
    # https://github.com/V4bel/dirtyfrag
    ++ ''
      install esp4 ${lib.getExe' pkgs.coreutils "false"}
      install esp6 ${lib.getExe' pkgs.coreutils "false"}
      install rxrpc ${lib.getExe' pkgs.coreutils "false"}
    '';

  # https://github.com/V4bel/dirtyfrag
  # IPSec and AFS
  boot.blacklistedKernelModules = [
    "esp4"
    "esp6"
    "rxrpc"
  ];
}
