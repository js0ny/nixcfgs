{
  flake.homeModules.cherry-studio =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      dotDir = ".local/share/CherryStudio";
      electronBase =
        if pkgs.stdenv.hostPlatform.isDarwin then
          "${config.home.homeDirectory}/Library/Application Support"
        else
          "${config.xdg.configHome}";
    in
    {
      home.packages =
        if pkgs.stdenv.hostPlatform.isLinux then
          [
            (pkgs.nixpaks.cherry-studio.override {
              dotDir = dotDir;
              extraMnts = [ "Desktop" ];
            })
          ]
        else
          [ pkgs.cherry-studio ];
      js0ny.persist.stores.state.directories = [ ".config/CherryStudio" ];
      systemd.user.tmpfiles.rules = [
        "L+ ${config.home.homeDirectory}/${dotDir}/bin/uv - - - - ${lib.getExe pkgs.uv}"
        "L+ ${config.home.homeDirectory}/${dotDir}/bin/bun - - - - ${lib.getExe pkgs.bun}"
      ];
    };
}
