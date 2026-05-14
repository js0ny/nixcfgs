{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.programs.chromium.enable;
in
lib.mkIf cfg {
  programs.chromium = {
    enable = true;
    homepageLocation = "https://duckduckgo.com";
    defaultSearchProviderSearchURL = "https://duckduckgo.com?q={searchTerms}";
    # https://chromeenterprise.google/intl/en_uk/policies/
    extraOpts = {
      "BrowserSignin" = 1;
      "PasswordManagerEnabled" = false;
      "ExtensionManifestV2Availability" = 2;
      "DefaultBrowserSettingEnabled" = false;
    };
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
    ];
  };
}
