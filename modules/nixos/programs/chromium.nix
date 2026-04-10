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
    extraOpts = {
      "BrowserSignin" = 1;
      "PasswordManagerEnabled" = false;
      "ExtensionManifestV2Availability" = 2;
    };
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
    ];
  };
}
