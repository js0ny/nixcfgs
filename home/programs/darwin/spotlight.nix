{ ... }:
{
  targets.darwin.defaults."com.apple.Spotlight" = {
    # macOS 26 Spotlight
    # 不显示 iPhone Apps
    EnabledPreferenceRules = [
      "System.iphoneApps"
    ];
  };
}
