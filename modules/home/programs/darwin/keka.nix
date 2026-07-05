{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  home.packages = with pkgs; [ keka ];

  targets.darwin.defaults."com.aone.keka" = {
    SUAutomaticallyUpdate = 0;
    SUEnableAutomaticChecks = 0;
    SUHasLaunchedBefore = 1;

    CloseController = 0;
    UseGrowl = 1;

    AppearanceCustomDockTile = 1;
    AppearanceSquishFaceInDock = 1;
    AppearanceShowDockIcon = 1;
    ResizableWindows = 1;

    DefaultFormat = "ZSTD";
    DefaultMethod = 3;
    ExcludeMacForks = 1; # .DS_Store
    UseLongTarballExtension = 1;

  };

}
