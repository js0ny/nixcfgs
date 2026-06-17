{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  home.packages = with pkgs; [ skimpdf ];

  targets.darwin.defaults."net.sourceforge.skim-app.skim" = {
    SKLastSelectedPreferencePane = "GeneralPreferences";
    SKSavePasswordOption = 0; # don't use keychain
    SKTeXEditorArguments = "+%l|%c";
    SKTeXEditorCommand = "nvim";
    SKTeXEditorPreset = ""; # custom
    SUEnableAutomaticChecks = 0;
    SUHasLaunchedBefore = 1;
  };

}
