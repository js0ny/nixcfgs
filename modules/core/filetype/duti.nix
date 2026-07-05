{
  flake.homeModules.darwin =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      apps = config.nixdots.apps;
      duti = lib.getExe pkgs.duti;
      iina = "com.colliderli.iina";
      keka = "com.aone.keka";
      sioyek = "info.sioyek.sioyek";
      mkDutiCommands = app: extensions: map (ext: "${duti} -s ${app} ${ext} all") extensions;
      dutiMaps = {
        "${apps.editor.gui.bundleIdentifier}" = [
          "md"
          "json"
          "diff"
          "patch"
          "js"
          "ts"
          "txt"
          "xml"
          "nix"
          "yaml"
          "lock"
          "atom"
          "log"
        ];
        "${iina}" = [
          "mp4"
          "mkv"
        ];
        "${keka}" = [
          "7z"
          "zip"
          "rar"
          "tar"
        ];
        "${sioyek}" = [ "pdf" ];
      };
    in
    lib.mkIf pkgs.stdenv.isDarwin {
      home.sessionVariables.TERMINAL = apps.terminal.exe;
      home.packages = [
        pkgs.duti
        pkgs.defaultbrowser
      ];
      home.activation.setOSXCommonDefaultApps = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ${lib.concatStringsSep "\n" (lib.flatten (lib.mapAttrsToList mkDutiCommands dutiMaps))}
        ${lib.getExe pkgs.defaultbrowser} firefox # TODO: Changme
      '';
    };
}
