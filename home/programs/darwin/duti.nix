{
  pkgs,
  lib,
  ...
}:
let
  iina = "com.colliderli.iina";
  # firefox = "org.nixos.firefox";
  keka = "com.aone.keka";
  sioyek = "info.sioyek.sioyek";

  defaultApps = {
    "${iina}" = [
      "mp4"
      "mkv"
    ];
    # "${firefox}" = ["html"];
    "${keka}" = [
      "7z"
      "zip"
      "rar"
      "tar"
    ];
    "${sioyek}" = [ "pdf" ];
  };

  duti = lib.getExe pkgs.duti;
  mkDutiCommands = app: extensions: map (ext: "${duti} -s ${app} ${ext} all") extensions;
in
{
  home.packages = [ pkgs.duti ];

  home.activation.setOSXDefaultApps = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${lib.concatStringsSep "\n" (lib.flatten (lib.mapAttrsToList mkDutiCommands defaultApps))}
  '';
}
