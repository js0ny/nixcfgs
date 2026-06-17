{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  home.packages = with pkgs; [ ice-bar ];

  targets.darwin.defaults."com.jordanbaird.Ice" = {
    SUAutomaticallyUpdate = 0;
    SUEnableAutomaticChecks = 0;
    SUHasLaunchedBefore = 1;

    AutoRehide = 1;
    CanToggleAlwaysHiddenSection = 1;
    CustomIceIconIsTemplate = 0;
    EnableAlwaysHiddenSection = 0;
    HideApplicationMenus = 1;
    IceBarLocation = 0;
    ItemSpacingOffset = 0;
    UseIceBar = 0;
    RehideInterval = 15;
    RehideStrategy = 0;
    ShowAllSectionsOnUserDrag = 1;
    ShowIceIcon = 1;
    ShowOnClick = 1;
    ShowOnHover = 0;
    ShowOnHoverDelay = "0.2";
    ShowOnScroll = 0;

    "hasMigrated0_10_0" = 1;
    "hasMigrated0_10_1" = 1;
    "hasMigrated0_8_0" = 1;
  };
}
