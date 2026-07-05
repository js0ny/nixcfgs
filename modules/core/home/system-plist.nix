{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf pkgs.stdenv.isDarwin {
  targets.darwin = {
    defaults = {
      "com.apple.screencapture" = {
        location = config.home.customDirs.screenshots;
      };
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.apple.Spotlight" = {
        # macOS 26 Spotlight
        # 不显示 iPhone Apps
        EnabledPreferenceRules = [
          "System.iphoneApps"
        ];
      };
    };
  };
}
